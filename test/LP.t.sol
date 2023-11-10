// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/LP.sol"; 
import "../src/MyToken.sol";


contract LiquidityPoolTest is Test {
    MyToken tokenA;
    MyToken tokenB;
    LiquidityPool liquidityPool;
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    function setUp() public {
        tokenA = new MyToken("TokenA", "TA"); // Deploy your tokens A and B here
        tokenB = new MyToken("TokenB", "TB");
        liquidityPool = new LiquidityPool(tokenA, tokenB); // Deploy your LiquidityPool contract here
    }

    function testDepositAndWithdraw() public {
        // Test deposit and withdraw functions of the LiquidityPool contract
        tokenA.mint(alice, 1000e18);
        tokenB.mint(alice, 2000e18);

        vm.startPrank(alice);
        tokenA.approve(address(liquidityPool), 500e18);
        tokenB.approve(address(liquidityPool), 1000e18);        
        vm.stopPrank();

        vm.startPrank(alice);
        liquidityPool.deposit(500e18, 1000e18);
        vm.stopPrank();
        uint256 liquidityAmount = liquidityPool.calculateLiquidityAmount(500e18, 1000e18);
        assertEq(liquidityPool.liquidity(alice), liquidityAmount);

        vm.startPrank(alice);
        liquidityPool.withdraw(500e18);
        vm.stopPrank();
        assertEq(liquidityPool.liquidity(alice), liquidityAmount - 500e18);
    }

    function testSwap() public {
        // Test swap function of the LiquidityPool contract
        tokenA.mint(alice, 1000e18);
        tokenB.mint(alice, 2000e18);

        vm.startPrank(alice);
        tokenA.approve(address(liquidityPool), 500e18);
        tokenB.approve(address(liquidityPool), 1000e18);
        vm.stopPrank();

        vm.startPrank(alice);
        liquidityPool.deposit(500e18, 1000e18);
        vm.stopPrank();
        uint256 liquidityAmount = liquidityPool.calculateLiquidityAmount(500e18, 1000e18);
        assertEq(liquidityPool.liquidity(alice), liquidityAmount);

        vm.startPrank(alice);
        tokenA.approve(address(liquidityPool), 100e18);
        vm.stopPrank();

        uint256 balanceBeforeSwap = tokenB.balanceOf(alice);
        vm.startPrank(alice);
        liquidityPool.swap(100e18);
        vm.stopPrank();
        uint256 balanceAfterSwap = tokenB.balanceOf(alice);

        assert(balanceAfterSwap > balanceBeforeSwap); // Ensure tokenB balance increased after the swap
    }
}
