//
//  EntryView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct EntryView: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("SplashImage")
                    .scaleEffect(0.3)
                
                NavigationLink(isActive: self.$isActive) {
                    ContentView()
                } label: {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive.toggle()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
            
    }
}
