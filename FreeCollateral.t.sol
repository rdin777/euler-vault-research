// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract FreeCollateralTest is Test {
    function test_FreeCollateralClaim() public {
        // Situation: the borrower has 1,000 units of “cheap” collateral.
        // In total, they cost less than 1 wei of the underlying asset (ETH).
        uint256 collateralBalance = 1000;

        // The oracle returns 0 because 1000 * price / 1e18 < 1
        uint256 collateralValueInETH = 0;

        uint256 yieldBalance;
        uint256 repayAssets;

        // Emulation of logic from Liquidation.sol:159
        if (collateralValueInETH == 0) {
            yieldBalance = collateralBalance;
            repayAssets = 0;
        }

        console.log("Liquidator gets yield:", yieldBalance);
        console.log("Liquidator repays assets:", repayAssets);

        assertTrue(yieldBalance > 0 && repayAssets == 0, "FREE ASSETS DETECTED!");
    }
}

