//
//  FileRowView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct FileRowView: View {
    let file: File
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(file.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Text(file.type.uppercased())
                    .foregroundColor(.gray)
                
                Text(file.desc)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("View")
                .foregroundColor(.accentColor)
        }
        .padding(5)
    }
}

struct FileRowView_Previews: PreviewProvider {
    static var previews: some View {
        FileRowView(file: File(value: ["name": "hello.pdf", "desc": "This is a description", "type": "PDF"]))
    }
}
