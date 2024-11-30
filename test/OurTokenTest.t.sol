// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address public USER = makeAddr("user");
    address public OWNER;
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        OWNER = msg.sender;
    }

    // Deployment Tests
    function testInitialSupplyIsCorrect() public {
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY);
    }

    function testOwnerHasInitialSupply() public {
        assertEq(ourToken.balanceOf(OWNER), INITIAL_SUPPLY);
    }

    // Token Metadata Tests
    function testTokenName() public {
        assertEq(ourToken.name(), "scofiedlTok");
    }

    function testTokenSymbol() public {
        assertEq(ourToken.symbol(), "ST");
    }

    function testTokenDecimals() public {
        assertEq(ourToken.decimals(), 18);
    }

    // Transfer Tests
    function testTransferTokens() public {
        uint256 transferAmount = 100 ether;
        vm.prank(OWNER);
        ourToken.transfer(USER, transferAmount);

        assertEq(ourToken.balanceOf(USER), transferAmount);
        assertEq(ourToken.balanceOf(OWNER), INITIAL_SUPPLY - transferAmount);
    }

    // Approval and Allowance Tests
    function testApproveAndAllowance() public {
        uint256 approvalAmount = 50 ether;
        
        vm.prank(OWNER);
        ourToken.approve(USER, approvalAmount);

        assertEq(ourToken.allowance(OWNER, USER), approvalAmount);
    }

    function testTransferFrom() public {
        uint256 transferAmount = 50 ether;
        
        vm.prank(OWNER);
        ourToken.approve(USER, transferAmount);

        vm.prank(USER);
        ourToken.transferFrom(OWNER, USER, transferAmount);

        assertEq(ourToken.balanceOf(USER), transferAmount);
        assertEq(ourToken.allowance(OWNER, USER), 0);
    }

    // Edge Case Tests
    function testZeroAddressTransferFails() public {
        vm.expectRevert();
        ourToken.transfer(address(0), 1 ether);
    }

    function testTransferZeroAmount() public {
        vm.prank(OWNER);
        bool success = ourToken.transfer(USER, 0);
        assertTrue(success);
    }

    // Fuzz Testing
    function testFuzzTransfer(uint96 amount) public {
        vm.assume(amount <= INITIAL_SUPPLY);
        
        vm.prank(OWNER);
        ourToken.transfer(USER, amount);

        assertEq(ourToken.balanceOf(USER), amount);
        assertEq(ourToken.balanceOf(OWNER), INITIAL_SUPPLY - amount);
    }
}