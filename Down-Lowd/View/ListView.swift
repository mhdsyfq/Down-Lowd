//
//  ListView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
            FileRowView(name: "syafiq.pdf", description: "this is my pdf", type: "PDF")
            
            FileRowView(name: "syafiq.pdf", description: "this is my pdf", type: "PDF")
            
            FileRowView(name: "syafiq.pdf", description: "this is my pdf", type: "PDF")
        }
        .navigationTitle("Downloaded Files")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
