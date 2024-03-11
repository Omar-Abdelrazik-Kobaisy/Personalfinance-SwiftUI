//
//  PaymentDetailViewModel.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import Foundation

class PaymentDetailViewModel: ObservableObject{
    var payment: PaymentActivity
    
    var typeIcon: String{
        
        let icon: String
        
        switch payment.type {
        case .income: icon = "arrowtriangle.up.circle.fill"
        case .expense : icon = "arrowtriangle.down.circle.fill"
        }
        
        return icon
    }
    
    var name: String{
        payment.name
    }
    
    var date: String{
        payment.date.string()
    }
    
    var address: String{
        payment.address ?? ""
    }
    
    var amount: String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        
        let formattedValue = formatter.string(from: NSNumber(value: payment.amount)) ?? ""
        
        
        return (payment.type == .income ? "+" : "-") + "$" + formattedValue
    }
    
    var memo: String{
        payment.memo ?? ""
    }
    
    init(payment: PaymentActivity) {
        self.payment = payment
    }
}
