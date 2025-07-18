//
//  AddView.swift
//  iExpense
//
//  Created by Santhosh Srinivas on 02/07/25.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var currency = "USD"
    @State private var amount = 0.0
    let types = ["Business", "Personal"]
    let currencies = ["INR", "USD", "EUR", "GBP", "JPY"]
    var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            Form{
                TextField("Enter the name: ", text: $name)
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                Picker("Currency", selection: $currency){
                    ForEach(currencies, id: \.self){
                        Text($0)
                    }
                }
                TextField("How Much?", value: $amount, format: .currency(code: currency))
                    .keyboardType(.decimalPad)

            }
            .navigationTitle("Add a new Expense")
            .toolbar{
                Button("Done"){
                    let newItem = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    expenses.items.append(newItem)
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
