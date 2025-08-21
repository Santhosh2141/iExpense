//
//  ContentView.swift
//  iExpense
//
//  Created by Santhosh Srinivas on 24/06/25.
//

import SwiftUI

// struct will create a new obj for each change and each obj wont share any data. itll be unique.
// but classes will share data.

//class User : ObservableObject{
    // we use : ObservableObject and @Published in ios14
    // in case of ios15+ we just add @Observable at top
//    @Published var firstName = "Jake"
//    @Published var lastName = "Peralta"
//}
//
//struct Person : Codable {
//    let firstName: String
//    let lastName: String
//}
//
//struct SecondView: View {
//
//    let name: String
//    @Environment(\.dismiss) var dismiss
    // this lets user dismiss the sheet automatically instead of a swipe by the user
//    var body: some View {
//        VStack{
//            Text("Second View; \(name)")
//            Button("Dismiss"){
//                dismiss()
//            }
//        }
//    }
//}

struct ExpenseItem : Identifiable, Codable{
    // adding Identifiable means this type can be identified uniquely and this should have an id item in it. One advantage is we dont need to add id in the forEach as it is identifiable

    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
}

class Expenses: ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItem = UserDefaults.standard.data(forKey: "Items"){
            // decode it into ExpenseItem from saveItem. using .self, we mean we’re referring to the type itself, known as the type object
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItem) {
                items = decoded
                return
            }
        }
        items = []
    }
    var personalItems: [ExpenseItem] {
      items.filter { $0.type == "Personal"}
    }
    var businessItems: [ExpenseItem] {
      items.filter { $0.type == "Business"}
    }
}

struct ContentView: View {
    // when we use class, it observes if the obj changes and not the value inside the class. so we have to add Observable/ ObservedObject and include @StateObject(only ios14)
//    @StateObject private var user = User()
//
//    @State private var showingSheet = false
//    @State private var num = [Int]()
//    @State private var currentNum = 1
//    @State private var buttonCount = UserDefaults.standard.integer(forKey: "Tap")
//
//    @AppStorage("tapCount") private var tapCount = 0
    // this is an easier way than UserDefaults. the value in quotes can be anything. not necessary that its the name of the var.
    //    This works like @State: when the value changes, it will reinvoked the body property so our UI reflects the new data.
    //    right now at least @AppStorage doesn’t make it easy to handle storing complex objects such as Swift structs
    
//    @State private var person = Person(firstName: "Ed", lastName: "Sheeran")
    
    @StateObject private var expenses = Expenses()
    @State private var showSheet = false
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack{
            List{
                Section("Personal"){
                    ForEach(expenses.items.filter{
                        $0.type == "Personal"
                    }, id: \.id){ item in
                        HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }

                                Spacer()
                            Text(item.amount, format: .currency(code: item.currency))
                                .bold()
                                
                            }
                        .foregroundColor(
                            item.amount >= 100 ? .red : item.amount <= 10 ? .green : .blue)
                    }
                    .onDelete(perform: removePersonalItems)
                }
                Section("Business"){
                    ForEach(expenses.businessItems, id: \.id){ item in
                        HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }

                                Spacer()
                            Text(item.amount, format: .currency(code: item.currency))
                                .bold()
                                
                            }
                        .foregroundColor(
                            item.amount >= 100 ? .red : item.amount <= 10 ? .green : .blue)
                    }
                    .onDelete(perform: removeBusinessItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
//                Button{
//                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                    expenses.items.append(expense)
//                    showSheet.toggle()
                    NavigationLink{
                        AddView(expenses: expenses)
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add an Expense")
                        }
                    }
//                } label: {
//                    Label("Add Item", systemImage: "plus")
//
//                }
//                .sheet(isPresented: $showSheet){
//                    AddView(expenses: expenses)
//                }
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet){
        /*
         what we are doing here is
         offsets is a set of indices when we click delete.
         the indices are iterated over.
         were assigning the index to
         the first occurance where the items ID is equal to the deletedItem ID
         eg:
         [PI1,BI1,PI2,PI3]      PI2 to delete
         so take the Array has the deleted item at index 2.
         personalItems[offset] will be PI2 in the personalItem array
         we take that id and find the first occurance of the id in the expenseItems array.
         here the first occ is at index 2.
         so index is assigned as 2
         and the 2nd element is removed.
        */
        for offset in offsets{
                if let index = expenses.items.firstIndex(where:{ $0.id == expenses.personalItems[offset].id
            }) {
                expenses.items.remove(at: index)
            }
        }
    }
    func removeBusinessItems(at offsets: IndexSet){
        for offset in offsets{
                if let index = expenses.items.firstIndex(where:{ $0.id == expenses.businessItems[offset].id
            }) {
                expenses.items.remove(at: index)
            }
        }
    }
//        NavigationStack{
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Hello, \(user.firstName) \(user.lastName)")
//                TextField("First Name", text: $user.firstName)
//                TextField("Last Name", text: $user.lastName)
//                Button("Show Sheet"){
//                    showingSheet.toggle()
//                }
//                .sheet(isPresented: $showingSheet){
//                    SecondView(name: user.firstName)
//
//                }
//                // archiving data is done using JSONEncoder()
//                // dearchiving data using JSONDecoder()
//                Button("Save User") {
//                    let encoder = JSONEncoder()
//
//                    if let data = try? encoder.encode(person) {
//                        UserDefaults.standard.set(data, forKey: "PersonData")
//                    }
//                }
//
//                List{
//                    ForEach(num, id: \.self){
//                        Text("Row \($0)")
//                    }
//                    .onDelete(perform: removeRows)
//                    // onDelete works only on forEach we cant use it directly on the list
//                    Button("Button Count: \(buttonCount)"){
//                        buttonCount += 1
//                        UserDefaults.standard.set(buttonCount, forKey: "Tap")
//                        // this is used so that the value we use is saved when we quit app and reopen
//                    }
//                    Button("Tap Count: \(tapCount)"){
//                        tapCount += 1
//                    }
//                }
//
//                Button("Add New number"){
//                    num.append(currentNum)
//                    currentNum += 1
//                }
//
//
//            }
//            .padding()
//            .toolbar{
//                EditButton()
//            }
//        }
//    }
//
//    func removeRows(at offsets: IndexSet){
//        we need to implement a method that will receive a single parameter of type IndexSet. This is a bit like a set of integers, except it’s sorted, and it’s just telling us the positions of all the items in the ForEach that should be removed.
//
//        Because our ForEach was created entirely from a single array, we can actually just pass that index set straight to our numbers array – it has a special remove(atOffsets:) method that accepts an index set.
//        num.remove(atOffsets: offsets)
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
