//
//  ContentView.swift
//  iExpense
//
//  Created by Design Work on 2020-09-02.
//  Copyright © 2020 Ling Lu. All rights reserved.
//

import SwiftUI

class Expenses: ObservableObject{
    init(){
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
        
    }
    @Published var items = [ExpenseItem]() {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey:"items")
            }
            
        }
    }
}
struct ExpenseItem: Identifiable, Codable{
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items){item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                        Text("$\(item.amount)")
                            .watermarked(item.amount)
                            
                    }
                    
                }.onDelete(perform: removeItems)
                
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading:EditButton(), trailing:
                Button(action:{
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
            
        }.sheet(isPresented: $showingAddExpense){
            AddView(expenses: self.expenses)
        }
       
    }
    func removeItems(at offset:IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
    
    
}
struct amountFormat_sm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct amountFormat_med: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
struct amountFormat_lrg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
//            .frame(width:80)
            .padding()
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
extension View {
    func watermarked(_ amount: Int) -> some View {
        
        if amount <= 10 {
            return AnyView(self.modifier(amountFormat_sm()))
        }else if amount < 100{
            return AnyView(self.modifier(amountFormat_med()))
        }else{
            return AnyView(self.modifier(amountFormat_lrg()))
        }
        
//        self.modifier(amountFormat_sm())
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
