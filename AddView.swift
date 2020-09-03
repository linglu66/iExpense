//
//  AddView.swift
//  iExpense
//
//  Created by Design Work on 2020-09-03.
//  Copyright © 2020 Ling Lu. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @State private var expenseName = ""
    @State private var expenseTypeSelection = "Personal"
    @State private var amount = ""
    let expenseTypes = ["Personal","Business"]
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var show
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Expense name", text: $expenseName)
                Picker("Type", selection: $expenseTypeSelection){
                    ForEach(self.expenseTypes, id:\.self){
                        Text("\($0)")
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
//                Button("Add"){
//                    self.AddExpense()
//                }
            }
        .navigationBarTitle("Add Expense")
            .navigationBarItems(trailing: Button("Save") {
                
                    let item = ExpenseItem(name: self.expenseName,
                                           type: self.expenseTypeSelection,
                                           amount: Int(self.amount) ?? 0)
                    self.expenses.items.append(item)
                self.show.wrappedValue.dismiss()
                
            })
        
        }
        
    }
    func AddExpense(){
        expenses.items.append(ExpenseItem(name: self.expenseName,
                                          type: self.expenseTypeSelection,
            amount:Int(self.amount) ?? 0))
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
