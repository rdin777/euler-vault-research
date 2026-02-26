// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract FeeLeakTest is Test {
    uint256 constant SHIFT = 31;
    uint256 constant CONFIG_SCALE = 10_000;
    uint256 constant INTEREST_FEE = 1000; // 10%

    function test_InterestFeeGrinding() public {
        // We emulate debt growth between transactions (for example, 20,000 units of Owed have accumulated).
        // This is realistic for short periods of time.
        uint256 debtGrowth = 20_000;

        // Calculation of the numerator
        uint256 numerator = debtGrowth * INTEREST_FEE;

        // Calculation of the divisor from Cache.sol
        uint256 denominator = CONFIG_SCALE << SHIFT;

        uint256 feeAssets = numerator / denominator;

        console.log("Debt Growth (Owed):", debtGrowth);
        console.log("Numerator:", numerator);
        console.log("Denominator:", denominator);
        console.log("Fee Assets earned:", feeAssets);

        // If there was debt growth but the commission was 0, the protocol loses money.
        assertEq(feeAssets, 0, "Protocol should have earned 0 due to precision loss");
        assertTrue(debtGrowth > 0, "Debt actually grew, but fee was lost");
    }
}
