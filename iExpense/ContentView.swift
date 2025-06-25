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
    
    var body: some View {
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
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
