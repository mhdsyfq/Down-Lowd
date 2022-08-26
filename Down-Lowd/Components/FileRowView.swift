//
//  FileRowView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct FileRowView: View {
    let name: String
    let description: String
    let type: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(type)
                    .foregroundColor(.gray)
                
                Text(description)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct FileRowView_Previews: PreviewProvider {
    static var name = "haha.pdf"
    static var description = "idk what pdf this is"
    static var type = "PDF"
    
    static var previews: some View {
        FileRowView(name: self.name, description: self.description, type: self.type)
    }
}
