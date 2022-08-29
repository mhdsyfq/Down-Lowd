//
//  RealmManager.swift
//  Down-Lowd
//
//  Created by Muhd Syafiq Bin Abas on 26/8/22.
//

import Foundation
import RealmSwift
import SwiftUI

class RealmManager: NSObject, ObservableObject, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    private(set) var localRealm: Realm?
    @Published private(set) var files: [File] = []
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isShowingAlert = false
    
    @Published var urlString = ""
    @Published var desc = ""
    
    @Published var selectedType = "Image"
    @Published var isExpanded = false
    var contentTypes = ["Image", "Audio", "Video", "PDF", "Others"]
    
    @Published var downloadProgress: CGFloat = 0
    @Published var isShowingProgress = false
    
    @Published var urlSessionDownloadTask: URLSessionDownloadTask!
    
    override init() {
        super.init()
        openRealm()
        getFiles()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func downloadAndAddFile() {
        // to allow for unicode characters
        self.urlString = self.urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: self.urlString) else {
            self.showAlert(title: "Error", message: "invalid URL")
            return
        }
        
        let manager = FileManager.default
        guard let path = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let destination = path.appendingPathComponent(url.lastPathComponent)
        
        if manager.fileExists(atPath: destination.path) {
            clearValues()
            showAlert(title: "Duplicate File", message: "you have already downloaded this file!")
        } else {
            self.downloadProgress = 0
            withAnimation {
                self.isShowingProgress = true
            }
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            urlSessionDownloadTask = session.downloadTask(with: url)
            urlSessionDownloadTask.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "something went wrong, please try again")
            }
            return
        }
        
        let manager = FileManager.default
        guard let path = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let destination = path.appendingPathComponent(url.lastPathComponent)
        
        do {
            try manager.copyItem(at: location, to: destination)
            print("Successfully downloaded!")
            
            DispatchQueue.main.async {
                self.addFile(name: url.lastPathComponent)
            }
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "something went wrong, please try again")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            // check if content length provided
            if CGFloat(totalBytesExpectedToWrite) == -1.0 {
                self.downloadProgress = -1.0
            } else {
                self.downloadProgress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.isShowingProgress = false
                if error.localizedDescription != "cancelled" {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func cancelDownload() {
        if let task = urlSessionDownloadTask, task.state == .running {
            urlSessionDownloadTask.cancel()
            withAnimation {
                self.isShowingProgress = false
            }
        }
    }
    
    func addFile(name: String) {
        openRealm()
        
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newFile = File(value: ["name": name, "desc": self.desc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "No description provided" : self.desc, "type": self.selectedType])
                    localRealm.add(newFile)
                    getFiles()
                    clearValues()
                    
                    print("Successfully added new file to Realm: \(newFile)")
                    
                    withAnimation {
                        self.isShowingProgress = false
                    }
                    self.showAlert(title: "Success", message: "file has been downloaded!")
                }
            } catch {
                print("Error adding file to Realm: \(error)")
            }
        }
    }
    
    func getFiles() {
        openRealm()
        
        if let localRealm = localRealm {
            let filesTemp = localRealm.objects(File.self)
            
            self.files = []
            filesTemp.forEach { file in
                self.files.append(file)
            }
        }
    }
    
    func openFile(name: String) {
        let manager = FileManager.default
        guard let path = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let destination = path.appendingPathComponent(name)
        
        let controller = UIDocumentInteractionController(url: destination)
        controller.delegate = self
        controller.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    func clearValues() {
        self.urlString = ""
        self.desc = ""
        self.selectedType = "Image"
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        self.isShowingAlert.toggle()
    }
}

