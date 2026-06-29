// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.34;

import {Test} from "forge-std/Test.sol";
import {Registry} from "registry/Registry.sol";
import {TokenSaleFund} from "sale/TokenSaleFund.sol";

contract Registration is Test {
    Registry public reg;
    TokenSaleFund public fund;
    address public constant ADMIN = 0x1010101010101010101010101010101010101010;
    address public constant SOMEONE = 0x6060606060606060606060606060606060606060;
    address public constant WHATEVER = 0x4040404040404040404040404040404040404040;
    bytes32 public constant SALE_ID = keccak256("abc-123");

    function setUp() public {
        // registry expects the registered target to be an actual contract
        fund = new TokenSaleFund(100, SALE_ID);
        reg = new Registry();
        // must be assigned register level
        reg.grantRoles(ADMIN, reg.REGISTER_LEVEL() + reg.DEREGISTER_LEVEL());
    }

    function testRevertNotRegistrar() public {
        vm.prank(SOMEONE);
        vm.expectRevert();
        reg.register(SALE_ID, 0, WHATEVER);
    }

    function testRevertNotContract() public {
        vm.prank(ADMIN);
        vm.expectRevert();
        reg.register(SALE_ID, 0, WHATEVER);
    }

    function testRegister() public {
        vm.startPrank(ADMIN);
        assertEq(reg.register(SALE_ID, fund.KIND(), address(fund)), true);
        assertEq(reg.registered(SALE_ID, fund.KIND()), address(fund));
        vm.stopPrank();
    }

    function testRevertAlreadyRegistered() public {
        // so that the expect revert doesn't trigger on KIND()
        uint256 kind = fund.KIND();

        vm.startPrank(ADMIN);
        assertEq(reg.register(SALE_ID, kind, address(fund)), true);
        assertEq(reg.registered(SALE_ID, kind), address(fund));

        vm.expectRevert();
        reg.register(SALE_ID, kind, address(fund));
        vm.stopPrank();
    }

    function testRevertNotDeregistrar() public {
        vm.expectRevert();
        reg.deregister(SALE_ID, 0);
    }

    function testDeregister() public {
        vm.startPrank(ADMIN);
        assertEq(reg.register(SALE_ID, fund.KIND(), address(fund)), true);
        assertEq(reg.registered(SALE_ID, fund.KIND()), address(fund));
        assertEq(reg.deregister(SALE_ID, fund.KIND()), true);
        assertEq(reg.registered(SALE_ID, fund.KIND()), address(0));
    }

    function testReregister() public {
        vm.startPrank(ADMIN);
        assertEq(reg.register(SALE_ID, fund.KIND(), address(fund)), true);
        assertEq(reg.registered(SALE_ID, fund.KIND()), address(fund));
        assertEq(reg.deregister(SALE_ID, fund.KIND()), true);
        assertEq(reg.registered(SALE_ID, fund.KIND()), address(0));
        assertEq(reg.register(SALE_ID, fund.KIND(), address(fund)), true);
    }
}
