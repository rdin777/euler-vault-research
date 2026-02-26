// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Owed, Assets} from "../../src/EVault/shared/types/Types.sol";

contract AuditMathTest is Test {
    uint256 constant SHIFT = 31;

    function test_SocializationAccountingLeak_Proof() public {
        // 1. Creating debt: 1 wei + 1 unit of internal dust
        uint144 debtRaw = uint144((1 << SHIFT) + 1);

        // 2. Let's imitate the logic in BorrowUtils.sol:61
        // Assets owed = owedExact.toAssetsUp();
        uint256 assetsUp = (uint256(debtRaw) + (1 << SHIFT) - 1) >> SHIFT;

        // 3. We simulate socialization: we write off exactly 1 wei (the entire portion of the debt).
        uint256 assetsToRepay = 1;

        // 4. Calculating the balance as in BorrowUtils.sol:65
        // Owed owedRemaining = (owed - assetsToRepay).toOwed();
        uint256 remainingOwedRaw = (assetsUp - assetsToRepay) << SHIFT;

        console.log("Internal Debt before:", debtRaw);
        console.log("Assets calculated (Up):", assetsUp);
        console.log("Remaining Owed Leak (in internal units):", remainingOwedRaw);
        console.log("Remaining Debt in Assets:", remainingOwedRaw >> SHIFT);

        // Если remainingOwedRaw > 0, This means that the debt has NOT BEEN WRITTEN OFF, but has become HIGHER (1 wei).
        assertTrue(remainingOwedRaw > 0, "Accounting leak detected!");
        assertEq(remainingOwedRaw >> SHIFT, 1, "Debt inflated to 1 full asset unit!");
    }
}
