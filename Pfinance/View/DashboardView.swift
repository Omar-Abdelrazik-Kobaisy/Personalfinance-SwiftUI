//
//  DashboardView.swift
//  Pfinance
//
//  Created by Omar on 11/03/2024.
//

import SwiftUI

enum TransactionDisplayType: CaseIterable{
    case all
    case income
    case expense
    
    var title: String{
        switch self {
        case .all:
            return "All"
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
}

struct DashboardView: View {
    
//    var paymentActivities = [PaymentActivity]()
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: PaymentActivity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \PaymentActivity.date, ascending: false)])
    var paymentActivities: FetchedResults<PaymentActivity>
    @State private var isShowingPaymentForm: Bool = false
    @State private var listType: TransactionDisplayType = .all
    private var dashboardTitlebar: some View{
        HStack{
            Spacer()
            VStack(alignment:.center){
                Text(Date().today())
                    .font(.system(.subheadline))
                    .foregroundColor(.secondary)
                Text("Personal Finance")
                    .font(.system(.title,design: .serif,weight: .bold))
            }
            Spacer()
            Button {
                self.isShowingPaymentForm = true
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }

        }
    }
    
    private var totalIncome: Double {
        let total = paymentActivities
            .filter({
                $0.type == .income
            })
            .reduce(0) {
                $0 + $1.amount
            }
        return total
    }
    
    private var totalExpense: Double{
        let total = paymentActivities
            .filter({
                $0.type == .expense
            })
            .reduce(0) {
                $0 + $1.amount
            }
        return total
    }
    
    private var totalBalance: Double{
        totalIncome - totalExpense
    }
    
    private var paymentDataForView: [PaymentActivity]{
        switch listType {
        case .all:
            return paymentActivities
                .sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        case .income:
            return paymentActivities
                .filter({$0.type == .income})
                .sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        case .expense:
            return paymentActivities
                .filter({$0.type == .expense})
                .sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        }
    }
    
    private var content: some View{
        ScrollView {
            VStack{
                dashboardTitlebar
                VStack(spacing:15){
                    CurrencyCard(title: "Total Balance",
                                 amount: totalBalance,
                                 color: .blue,
                                 height: 200)
                    HStack(spacing:15){
                        CurrencyCard(title: "Income",
                                     amount: totalIncome,
                                     color: Color("InCome"),
                                     height: 150)
                        CurrencyCard(title: "Expense",
                                     amount: totalExpense,
                                     color: .red,
                                     height: 150)
                    }
                }
                TransactionHeader(listType: $listType)
                
                ForEach(paymentDataForView) { payment in
                    TransactionCellView(payment: payment)
                }
            }
            .padding(.horizontal)
        }
    }
    var body: some View {
        content
            .sheet(isPresented: $isShowingPaymentForm) {
                PaymentFormView()
            }
    }
    
}

struct CurrencyCard: View{
    let title: String
    let amount: Double
    let color: Color
    let height: CGFloat
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(color)
            
            VStack(spacing: 5){
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle,design: .rounded,weight: .black))
                    .padding(.vertical)
                
                Text("$" + NumberFormatter.currency(from: amount))
                    .foregroundColor(.white)
                    .font(.system(.largeTitle,design: .rounded,weight: .black))
                    .minimumScaleFactor(0.2)
            }
        }
        .frame(height: height)
    }
}

struct TransactionHeader: View{
    @Binding var listType: TransactionDisplayType
    
    var body: some View{
        VStack(alignment: .leading){
            Text("Recent transactions")
                .font(.headline)
                .fontWeight(.semibold)
            HStack{
                ForEach(TransactionDisplayType.allCases,id: \.self) { transType in
                    
                    Button {
                        listType = transType
                    } label: {
                        Text(transType.title)
                            .foregroundColor(.white)
                            .padding(3)
                            .padding(.horizontal , 10)
                            .background(listType == transType ? .indigo : .secondary)
                    }
                    .cornerRadius(15)
                }
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct TransactionCellView: View{
    @ObservedObject var payment: PaymentActivity
    var body: some View{
        HStack(spacing:15){
            Image(systemName: payment.type == .income ?
                    "arrowtriangle.up.circle.fill" :
                    "arrowtriangle.down.circle.fill")
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white,
                             payment.type == .income ?
                             .indigo : .red)
            VStack{
                Text(payment.name)
                    .font(.headline)
                Text(payment.date.string(with: "dd MMMM yyyy"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            Text((payment.type == .income ? "+$" : "-$") + NumberFormatter.currency(from: payment.amount))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        CurrencyCard(title: "Total Balance",
                     amount: 12000, color: .red, height: 200)
        TransactionCellView(payment:testTrans)
            .previewLayout(.sizeThatFits)
    }
}
