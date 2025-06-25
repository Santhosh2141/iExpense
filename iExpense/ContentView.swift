//
//  ContentView.swift
//  iExpense
//
//  Created by Santhosh Srinivas on 24/06/25.
//

import SwiftUI

// struct will create a new obj for each change and each obj wont share any data. itll be unique.
// but classes will share data.

class User : ObservableObject{
    // we use : ObservableObject and @Published in ios14
    // in case of ios15+ we just add @Observable at top
    @Published var firstName = "Jake"
    @Published var lastName = "Peralta"
}

struct Person : Codable {
    let firstName: String
    let lastName: String
}

struct SecondView: View {
    
    let name: String
    @Environment(\.dismiss) var dismiss
    // this lets user dismiss the sheet automatically instead of a swipe by the user
    var body: some View {
        VStack{
            Text("Second View; \(name)")
            Button("Dismiss"){
                dismiss()
            }
        }
    }
}
struct ContentView: View {
    // when we use class, it observes if the obj changes and not the value inside the class. so we have to add Observable/ ObservedObject and include @StateObject(only ios14)
    @StateObject private var user = User()
    
    @State private var showingSheet = false
    @State private var num = [Int]()
    @State private var currentNum = 1
    @State private var buttonCount = UserDefaults.standard.integer(forKey: "Tap")
    
    @AppStorage("tapCount") private var tapCount = 0
    // this is an easier way than UserDefaults. the value in quotes can be anything. not necessary that its the name of the var.
    //    This works like @State: when the value changes, it will reinvoked the body property so our UI reflects the new data.
    //    right now at least @AppStorage doesn’t make it easy to handle storing complex objects such as Swift structs
    
    @State private var person = Person(firstName: "Ed", lastName: "Sheeran")
    
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, \(user.firstName) \(user.lastName)")
                TextField("First Name", text: $user.firstName)
                TextField("Last Name", text: $user.lastName)
                Button("Show Sheet"){
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet){
                    SecondView(name: user.firstName)
                    
                }
                // archiving data is done using JSONEncoder()
                // dearchiving data using JSONDecoder()
                Button("Save User") {
                    let encoder = JSONEncoder()

                    if let data = try? encoder.encode(person) {
                        UserDefaults.standard.set(data, forKey: "PersonData")
                    }
                }
                
                List{
                    ForEach(num, id: \.self){
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                    // onDelete works only on forEach we cant use it directly on the list
                    Button("Button Count: \(buttonCount)"){
                        buttonCount += 1
                        UserDefaults.standard.set(buttonCount, forKey: "Tap")
                        // this is used so that the value we use is saved when we quit app and reopen
                    }
                    Button("Tap Count: \(tapCount)"){
                        tapCount += 1
                    }
                }
                
                Button("Add New number"){
                    num.append(currentNum)
                    currentNum += 1
                }
                
                
            }
            .padding()
            .toolbar{
                EditButton()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet){
//        we need to implement a method that will receive a single parameter of type IndexSet. This is a bit like a set of integers, except it’s sorted, and it’s just telling us the positions of all the items in the ForEach that should be removed.
//
//        Because our ForEach was created entirely from a single array, we can actually just pass that index set straight to our numbers array – it has a special remove(atOffsets:) method that accepts an index set.
        num.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
