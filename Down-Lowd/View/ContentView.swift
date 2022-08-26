//
//  ContentView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Hello, what would you like to do?")
                .font(.title3)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 10) {
                NavigationLink {
                    DownloadView()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Download a File")
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor))
                }
                
                NavigationLink {
                    
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("View List")
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor))
                }
            }
        }
        .navigationBarHidden(true)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
