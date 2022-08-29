//
//  ListView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var rm: RealmManager
    
    var body: some View {
        VStack {
            if rm.files.isEmpty {
                Text("You have not downloaded any files yet!")
            } else {
                List(rm.files) { file in
                    Button {
                        rm.openFile(name: file.name)
                    } label: {
                        FileRowView(file: file)
                    }
                }
            }
        }
        .navigationTitle("Downloaded Files")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: self.$rm.isShowingAlert) {
            Alert(title: Text(self.rm.alertTitle), message: Text(self.rm.alertMessage), dismissButton: .destructive(Text("OK")) {
            })
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(RealmManager())
    }
}
