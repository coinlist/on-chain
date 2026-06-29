# CoinList — Ethereum Contracts

Solidity contracts that power CoinList token sales. The core flow is a two-stage
pipeline: users' funds are gathered in a **Fund** (`commit`), and tokens are later
handed out by a **Distribution** (`distribute`). A separate **Swap** family provides
an alternate, integration-driven acquisition path.

Contracts are written in Solidity `0.8.34`, built and tested with
[Foundry](https://book.getfoundry.sh/), and depend on
[solady](https://github.com/Vectorized/solady) via [soldeer](https://soldeer.xyz/).

## Core concepts

### Sale id

Every deployed sale contract carries a `bytes32 id` — the unique identifier of the
sale it serves. The same `id` ties together a sale's Fund and Dist deployments.

### Kinds

Each deployable contract reports a `KIND` constant. The Registry keys deployments by
`(id, kind)`, so a single sale `id` can resolve to one contract of each kind.

| KIND | Contract        | Role in the system                                      |
|:----:|:----------------|:--------------------------------------------------------|
| `0`  | Sale Fund       | Collects funding (`commit`) and returns it (`remit`)    |
| `1`  | Sale Distribution | Pushes a token out to users (`distribute`)            |
| `2`  | Swap            | Swaps an input token for an output token                |

Contracts also expose a `VERSION` constant, bumped as features are added/refined.

### Registry key

```
registered[id][kind] => deployment address
```

A `(id, kind)` slot may be set once (registration reverts if non-zero) and cleared
via deregistration.

### Lifecycle primitives

Two distinct lifecycle mixins live in `lib/shared` and are applied to different
families:

- **`Stopable`** (Sale contracts) — a single `uint256 stopped` bitmask. `stop(level)`
  sets it to any value (reversible). The `started(level)` modifier reverts with
  `IsStopped` when `(stopped & level) != 0`. Owner-only on the Sale contracts.
- **`Operable`** (Swap contracts) — separate `paused` (a `uint32` bitmask, reversible
  via `pause(level)`) and `stopped` (a one-way `stop()`, not reversible). `status()`
  returns a `Status { State, uint32 flags }` where `State` is `Active | Paused |
  Stopped`. The `active(level)` modifier reverts on `IsStopped` or when the level bit
  is paused.


## Contracts

### Registry — `src/registry/Registry.sol`

On-chain directory mapping `(id, kind)` to a deployment address.

### Factory — `src/factory/Factory.sol`

Deploys Sale contracts, hands ownership to `deploymentOwner`, and registers them.

### TokenSaleFund — `src/sale/TokenSaleFund.sol` · kind `0`

Collects funding per `(user, option, token)`. Tracks `SaleTotal { commitCount, commitSum, remitCount, remitSum }`;

### TokenSaleDist — `src/sale/TokenSaleDist.sol` · kind `1`

Distributes a single, fixed `distToken`. Inherits `Stopable`, `OwnableRoles`.
Tracks `DistTotal { distCount, distSum }`.


### TokenSwap — `src/swap/TokenSwap.sol` · kind `2`

Abstract base for performing on chain token swaps. Tracks
`SwapTotal { inputSum, feeSum, outputSum, count }`.


## Shared library — `lib/shared`

Generic primitives used across `src/`.

- **`operable/Operable.sol`** — the Swap lifecycle mixin (`pause` / `stop` / `status`,
  `active` modifier).
- **`stopable/Stopable.sol`** — the Sale lifecycle mixin (`stop(level)`, `started`
  modifier).
- **`Utils.sol`** — `isContract(address)`, a free function using `extcodesize`.
- **`TestToken.sol`** — a mintable solady `ERC20` used only by the test suite.

## Build & test

Dependencies are managed with [soldeer](https://soldeer.xyz/) and pinned in
`soldeer.lock`; remappings are generated into `remappings.txt`.

```sh
forge soldeer install   # populate dependencies/ from soldeer.lock

forge build
forge test
```

A `ci` profile (`FOUNDRY_PROFILE=ci`) raises verbosity for CI runs. RPC and Etherscan
config for `sepolia` / `anvil` is read from the environment (`SEPOLIA_RPC_URL`,
`ANVIL_RPC_URL`, `ETHERSCAN_API_KEY`).
