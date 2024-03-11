//
//  PaymentDetailView.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import SwiftUI

struct PaymentDetailView: View {
    @StateObject private var vm: PaymentDetailViewModel
    var payment: PaymentActivity
    init(payment: PaymentActivity){
        self.payment = payment
        self._vm = StateObject(wrappedValue: PaymentDetailViewModel(payment: payment))
    }
    var body: some View {
        VStack{
            TitleBar(icon: vm.typeIcon)
            
            Image("payment-detail")
                .resizable()
                .scaledToFit()
            
            PaymentInfo(viewModel: self.vm)
            
            Divider()
                .padding(.top)
            
            VStack(alignment:.leading,spacing: 8){
                Text("Memo")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(vm.memo)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            
            Divider()
        }
        .padding()
    }
}

struct TitleBar: View{
    let icon: String
    var body: some View{
        HStack(spacing: 8){
            Text("Payment Details")
                .font(.system(.headline,design: .rounded,weight: .semibold))
            Image(systemName: icon)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct PaymentInfo: View{
    var viewModel: PaymentDetailViewModel
    var body: some View{
        HStack(alignment: .top){
            VStack(alignment: .leading,spacing: 10){
                Text("My Personal payment")
                    .font(.system(.title2,design: .rounded,weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Group {
                    Text(viewModel.date)
                    Text(viewModel.address)
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            }
            Spacer()
            Text(viewModel.amount)
                .font(.system(.title,design: .rounded,weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(payment: testTrans)
    }
}
