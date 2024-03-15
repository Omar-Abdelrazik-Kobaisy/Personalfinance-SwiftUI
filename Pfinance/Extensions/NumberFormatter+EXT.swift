//
//  NumberFormatter+EXT.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import Foundation

extension NumberFormatter{
    static func currency(from value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
