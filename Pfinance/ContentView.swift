//
//  ContentView.swift
//  Pfinance
//
//  Created by Omar on 09/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingSheet: Bool = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    isShowingSheet = true
                }
        }
        .padding()
        .sheet(isPresented: $isShowingSheet) {
            PaymentFormView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
