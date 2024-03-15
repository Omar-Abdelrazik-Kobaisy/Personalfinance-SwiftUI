//
//  Preview+EXT.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var testTrans: PaymentActivity {
        let context = PersistenceController.shared.container.viewContext
        let testTrans = PaymentActivity(context: context)
        testTrans.paymentId = UUID()
        testTrans.name = "test Transaction"
        testTrans.amount = 9999
        testTrans.type = .income
        testTrans.date = .now
        testTrans.address = "8. el-Basra Street behind Cairo Mall"
        testTrans.memo = "hope i can buy a new macBook M3 in this year"
        
        return testTrans
    }
}
