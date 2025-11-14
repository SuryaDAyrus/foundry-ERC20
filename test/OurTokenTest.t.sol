// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/OurToken.sol";
import "../script/DeployOurToken.s.sol";
import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address charlie = makeAddr("charlie");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        // transfer some balance to Bob
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // -----------------------------------------------------
    // BASIC TESTS
    // -----------------------------------------------------

    function testInitialSupply() public view {
        assertEq(
            ourToken.totalSupply(),
            1000 ether,
            "Initial supply should be 1000 ether"
        );
    }

    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testTransfer() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        ourToken.transfer(alice, amount);

        assertEq(ourToken.balanceOf(alice), amount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - amount);
    }

    // -----------------------------------------------------
    // ALLOWANCE TESTS
    // -----------------------------------------------------

    function testApprove() public {
        uint256 allowanceAmount = 5000;

        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);

        assertEq(ourToken.allowance(bob, alice), allowanceAmount);
    }

    // OZ v5 removes increaseAllowance/decreaseAllowance.
    // We simulate same behavior using approve().
    function testIncreaseDecreaseAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 100);
        assertEq(ourToken.allowance(bob, alice), 100);

        // Increase allowance (manual logic)
        vm.prank(bob);
        ourToken.approve(alice, 150);
        assertEq(ourToken.allowance(bob, alice), 150);

        // Decrease allowance (manual logic)
        vm.prank(bob);
        ourToken.approve(alice, 130);
        assertEq(ourToken.allowance(bob, alice), 130);
    }

    // -----------------------------------------------------
    // REVERT TESTS
    // -----------------------------------------------------

    function testTransferRevertsOnInsufficientBalance() public {
        vm.prank(alice); // alice has 0 tokens
        vm.expectRevert();
        ourToken.transfer(charlie, 1 ether);
    }

    function testTransferFromRevertsWhenAllowanceTooLow() public {
        vm.prank(bob);
        ourToken.approve(alice, 100); // only 100 approved

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 200); // trying to send 200
    }

    function testTransferFromRevertsWhenBalanceTooLow() public {
        vm.prank(bob);
        ourToken.approve(alice, 500); // approve enough

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, STARTING_BALANCE + 1); // send more than balance
    }

    // -----------------------------------------------------
    // EVENT TESTS
    // -----------------------------------------------------

// function testTransferEvent() public {
//     uint256 amount = 5 ether;

//     vm.prank(bob);
//     vm.expectEmit(true, true, false, true);

//    emit ERC20.Transfer(bob, alice, amount);

//     ourToken.transfer(alice, amount);
// }

// function testApprovalEvent() public {
//     uint256 amount = 123;

//     vm.prank(bob);
//     vm.expectEmit(true, true, false, true);

//    emit ERC20.Approval(bob, alice, amount);

//     ourToken.approve(alice, amount);
// }


    // -----------------------------------------------------
    // EDGE CASES
    // -----------------------------------------------------

    function testZeroTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 0);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
        assertEq(ourToken.balanceOf(alice), 0);
    }

    function testZeroApprove() public {
        vm.prank(bob);
        ourToken.approve(alice, 0);

        assertEq(ourToken.allowance(bob, alice), 0);
    }

    function testSelfApprove() public {
        vm.prank(bob);
        ourToken.approve(bob, 777);

        assertEq(ourToken.allowance(bob, bob), 777);
    }

    function testTransferToSelf() public {
        vm.prank(bob);
        ourToken.transfer(bob, 1 ether);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }
}
