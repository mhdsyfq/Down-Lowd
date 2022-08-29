//
//  ProgressBarView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct ProgressBarView: View {
    @EnvironmentObject var rm: RealmManager
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if rm.downloadProgress == -1.0 {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Unknown file size. Downloading...")
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 100)
                    .padding(20)
                } else {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.2)
                            .foregroundColor(Color.gray)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(min(self.rm.downloadProgress, 1)))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.accentColor)
                            .rotationEffect(Angle(degrees: 270))
                        
                        Text("\(Int(rm.downloadProgress * 100))%")
                    }
                    .frame(width: 80, height: 100)
                    .padding(20)
                }
                
                Divider()
                
                Button {
                    rm.cancelDownload()
                } label: {
                    Text("Cancel")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(15)
            }
            .frame(width: 200)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
            .environmentObject(RealmManager())
    }
}
