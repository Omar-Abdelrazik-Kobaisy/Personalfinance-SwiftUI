//
//  PaymentFormViewModel.swift
//  Pfinance
//
//  Created by Omar on 09/03/2024.
//

import Foundation
import Combine

class PaymentFormViewModel: ObservableObject{
    //MARK: Inputs
    @Published var name: String = ""
    @Published var type: PaymentCategory = .expense
    @Published var date: Date = Date()
    @Published var amount: String = "0.0"
    @Published var location: String = ""
    @Published var memo: String = ""
    //MARK: Outputs
    @Published var isValidName: Bool = false
    @Published var isValidAmount: Bool = false
    @Published var isMemoValid: Bool = false
    @Published var isFormInputValid: Bool = false
    
    private var cancellableSet = Set<AnyCancellable>()
    
    init(paymentActivity: PaymentActivity?){
        self.name = paymentActivity?.name ?? ""
        self.type = paymentActivity?.type ?? .expense
        self.date = paymentActivity?.date ?? .now
        self.amount = "\(paymentActivity?.amount ?? 0.0)"
        self.location = paymentActivity?.address ?? ""
        self.memo = paymentActivity?.memo ?? ""
        
        validation()
    }
    
    func validation(){
        $name
            .receive(on: RunLoop.main)
            .map { name in
                !name.isEmpty
            }
            .assign(to: \.isValidName, on: self)
            .store(in: &cancellableSet)
        $amount
            .receive(on: RunLoop.main)
            .map { amount in
                guard let validAmount = Double(amount)  else {return false}
                return !amount.isEmpty && validAmount > 0.0
            }
            .assign(to: \.isValidAmount, on: self)
            .store(in: &cancellableSet)
        
        $memo
            .receive(on: RunLoop.main)
            .map { memo in
                memo.count > 300
            }
            .assign(to: &$isMemoValid)
        
        Publishers.CombineLatest3($isValidName, $isValidAmount, $isMemoValid)
            .map{
                $0 && $1 && !$2
            }
            .assign(to: &$isFormInputValid)
    }
}
