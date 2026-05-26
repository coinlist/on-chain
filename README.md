# Contracts

This repository serves as the official public registry for smart contracts deployed by CoinList.
Its purpose is to host the smart contracts used for CoinList token sales, providing transparency
and enabling public review and audits of production code.

> **Note:** These contracts are provided for transparency and verification only. They are designed
> for CoinList-operated sales and are not intended as a development framework for third-party use.

## Security & Audits

Security is a primary focus for CoinList. Contracts in this repository undergo a professional
third-party security audits prior to use in a production environment. Audit reports are published
separately and may be referenced by CoinList and/or the auditing firms themselves. This repository
serves as the canonical source for the audited code.

### Responsible Disclosure

If you believe you have identified a security vulnerability:

1. **Do not** open a public GitHub issue.
2. Email **security@coinlist.co** with a detailed description of the issue.
3. Allow reasonable time for investigation and remediation prior to any public disclosure.

## Deployed Contracts

The following contracts have been used in production for CoinList offerings:

| Project | Address                                     | Chain            |
|---------|---------------------------------------------|------------------|
| Zama    | 0xE5Ae8f0C646dBc1111DbdED801A03Cf7CE0508b1  | Ethereum Mainnet |

## Repository Structure

The repository is organized by blockchain ecosystem and supporting documentation:

```text
    contracts/
    └── ethereum/
        └── sales/           # Solidity contracts for Ethereum token sales
```

## Usage Notes

- Contracts in this repository are **production** contracts, not examples.
- Deploying or modifying these contracts for third-party use is **not supported** by CoinList.
- Interaction with deployed contracts should occur only through official CoinList interfaces,
  unless explicitly documented otherwise on https://coinlist.co.

## Links

- **Official Website:** https://coinlist.co
- **Support:** https://support.coinlist.co
- **Security Contact:** security@coinlist.co
- **Status Page:** https://status.coinlist.co
