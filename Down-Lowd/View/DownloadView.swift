//
//  DownloadView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct DownloadView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rm: RealmManager
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Text("URL")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            TextField("http://", text: self.$rm.urlString)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                        }
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Description")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                
                                Spacer()
                                
                                Text("\(self.rm.desc.count)/100")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 5)
                            }
                            
                            TextEditor(text: self.$rm.desc)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .font(.body)
                                .padding(.leading, 12)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                                .onChange(of: self.rm.description, perform: {
                                    self.rm.desc = String($0.prefix(100))
                                })
                        }
                        
                        VStack(spacing: 10) {
                            Text("Content Type")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            DisclosureGroup(self.rm.selectedType, isExpanded: self.$rm.isExpanded) {
                                Divider()
                                    .padding(.vertical, 5)
                                
                                ForEach(self.rm.contentTypes, id: \.self) { ct in
                                    Button {
                                        self.rm.selectedType = ct
                                        
                                        withAnimation {
                                            self.rm.isExpanded.toggle()
                                        }
                                    } label: {
                                        HStack {
                                            Text(ct)
                                                .font(.body)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, 5)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .accentColor(.black)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button {
                    hideKeyboard()
                    rm.downloadAndAddFile()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Download")
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.accentColor))
                    .padding()
                }
            }
            
            if self.rm.isShowingProgress {
                ProgressBarView()
                    .environmentObject(rm)
            }
        }
        .navigationTitle("Download a File")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: self.$rm.isShowingAlert) {
            Alert(title: Text(self.rm.alertTitle), message: Text(self.rm.alertMessage), dismissButton: .destructive(Text("OK")) {
                if self.rm.alertTitle == "Success" {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
