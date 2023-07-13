// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "forge-std/Test.sol";
import "../src/MyToken.sol";


contract ContractTest is Test {
    MyToken token;
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);


    function setUp() public {
        token = new MyToken("MyToken", "MTK");
    }


    function testName() external {
        assertEq("MyToken", token.name());
    }


    function testSymbol() external {
        assertEq("MTK", token.symbol());
    }


    function testMint() public {
        token.mint(alice, 2e18);
        assertEq(2e18, token.balanceOf(alice));
        assertEq(2e18, token.totalSupply());
    }
   


    function testTransfer() external {
        testMint();
        vm.startPrank(alice);
        token.transfer(bob, 0.5e18);
        assertEq(token.balanceOf(bob), 0.5e18);
        assertEq(token.balanceOf(alice), 1.5e18);
        vm.stopPrank();
    }


    function testTransferFrom() external {
        testMint();
        vm.prank(alice);
        token.approve(address(this), 1e18);
        assertTrue(token.transferFrom(alice, bob, 0.7e18));
        assertEq(token.allowance(alice, address(this)), 1e18 - 0.7e18);
        assertEq(token.balanceOf(alice), 2e18 - 0.7e18);
        assertEq(token.balanceOf(bob), 0.7e18);
    }


  }
