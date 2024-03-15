//
//  PaymentFormView.swift
//  Pfinance
//
//  Created by Omar on 09/03/2024.
//

import SwiftUI

struct PaymentFormView: View {
    var payment: PaymentActivity?
    @StateObject private var paymentVM: PaymentFormViewModel
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    init(payment: PaymentActivity? = nil){
        self.payment = payment
        self._paymentVM = StateObject(wrappedValue: PaymentFormViewModel(paymentActivity: payment))
        
    }
    var body: some View {
        ScrollView {
            VStack{
                //MARK: Title bar
                HStack{
                    Text("New Payment")
                        .font(.system(.title,design: .rounded,weight: .black))
                    Spacer()
                    Button {
                        //dismiss
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(.title2,design: .rounded,weight: .semibold))
                            .foregroundColor(.black)
                    }

                }
                .padding(.vertical)
                //MARK: Validation
                Group {
                    if !paymentVM.isValidName{
                        ValidationErrorText(text: "Please enter the Payment name")
                    }
                    if !paymentVM.isValidAmount {
                        ValidationErrorText(text: "Please enter a valid amount")
                    }
                    if paymentVM.isMemoValid{
                        ValidationErrorText(text: "Your memo should not exceed 300 characters")
                    }
                }
                .padding(.vertical,1)
                
                FormTextField(name: "name",
                              placeHolder: "Enter your Payment",
                              text: $paymentVM.name)
                //MARK: Type
                VStack(alignment: .leading){
                    Text("TYPE")
                        .bold()
                    HStack{
                        Button {
                            self.paymentVM.type = .income
                        } label: {
                            Text("Income")
                                .font(.system(.title2,design: .rounded,weight: .semibold))
                                .padding()
                                .foregroundColor(self.paymentVM.type == .income ? .white : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        .background(self.paymentVM.type == .income ? Color("InCome") : .white)
                        Button {
                            self.paymentVM.type = .expense
                        } label: {
                            Text("Expense")
                                .font(.system(.title2,design: .rounded,weight: .semibold))
                                .padding()
                                .foregroundColor(self.paymentVM.type == .expense ? .white : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        .background(self.paymentVM.type == .expense ? .red : .white)

                    }
                    .border(.gray,width: 0.5)
                }
                //MARK: Date & Amount
                HStack{
                    FormDateField(name: "date", date: $paymentVM.date)
                    FormTextField(name: "amount ($)",
                                  placeHolder: "0.0", text: $paymentVM.amount)
                }
                //MARK: Location
                FormTextField(name: "Locatoion (optional)",
                              placeHolder: "Where do you spend?",
                              text: $paymentVM.location)
                //MARK: memo
                FormTextEditor(name: "memo (optional)", text: $paymentVM.memo)
                
                //MARK: Save Button
                
                Button {
                    let newPayment = payment ?? PaymentActivity(context: context)
                    newPayment.paymentId = UUID()
                    newPayment.name = paymentVM.name
                    newPayment.type = paymentVM.type
                    newPayment.date = paymentVM.date
                    newPayment.amount = Double(paymentVM.amount) ?? 010
                    newPayment.address = paymentVM.location
                    newPayment.memo = paymentVM.memo
                    
                    guard let _ = try? context.save() else {
                        print("faild to save to dashboard ...")
                        return
                    }
                    
                } label: {
                    Text("Save")
                        .font(.system(.title2,design: .default,weight: .semibold))
                        .opacity(paymentVM.isFormInputValid ? 1.0 : 0.5)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("InCome"))
                        })
                        .padding()
                    
                }
                .disabled(!paymentVM.isFormInputValid)
            }
            .padding(.horizontal)
        }
    }
}
struct FormTextEditor: View{
    let name: String
    var height: CGFloat = 80.0
    @Binding var text: String
    
    var body: some View{
        VStack(alignment:.leading){
            Text(name.uppercased())
                .bold()
            TextEditor(text: $text)
                .frame(minHeight: height)
                .border(.gray,width: 0.5)
        }
        .padding(.bottom)
    }
}

struct FormDateField: View{
    let name: String
    
    @Binding var date: Date
    var body: some View{
        VStack(alignment: .leading){
            Text(name.uppercased())
                .bold()
            DatePicker("", selection: $date,
                       displayedComponents: .date)
            .padding(10)
            .border(.gray,width: 0.5)
            .labelsHidden()
        }
        .padding(.bottom)
    }
}
struct FormTextField: View{
    let name: String
    let placeHolder: String
    
    @Binding var text: String
    var body: some View{
        VStack{
            Text(name.uppercased())
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
            TextField(placeHolder, text: $text)
                .padding()
                .border(.gray,width: 0.5)
        }
        .padding(.bottom)
    }
}

struct ValidationErrorText: View{
    let iconName = "info.circle"
    let text: String
    var body: some View{
        HStack{
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.red)
            Text(text)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}
struct PaymentFormView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentFormView()
    }
}
