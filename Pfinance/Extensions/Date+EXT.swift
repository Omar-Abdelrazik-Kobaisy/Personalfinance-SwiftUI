//
//  Date+EXT.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import Foundation

extension Date{
    func string(with format: String = "dd MM yyyy") ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
