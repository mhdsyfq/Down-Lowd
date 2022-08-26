//
//  DownloadView.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import SwiftUI

struct DownloadView: View {
    @State private var urlString = ""
    @State private var description = ""
    
    @State private var selectedType = "Image"
    @State private var isExpanded = false
    
    var contentTypes = ["Image", "Video", "PDF", "Others"]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("URL")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                        
                        TextField("http://", text: self.$urlString)
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
                            
                            Text("\(self.description.count)/100")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 5)
                        }
                        
                        TextEditor(text: self.$description)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(.body)
                            .padding(.leading, 12)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                            .onChange(of: self.description, perform: {
                                self.description = String($0.prefix(100))
                            })
                    }
                    
                    VStack(spacing: 10) {
                        Text("Content Type")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                        
                        DisclosureGroup(self.selectedType, isExpanded: self.$isExpanded) {
                            Divider()
                                .padding(.vertical, 5)
                            
                            ForEach(self.contentTypes, id: \.self) { ct in
                                Button {
                                    self.selectedType = ct
                                    
                                    withAnimation {
                                        self.isExpanded.toggle()
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
        .navigationTitle("Download a File")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
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
