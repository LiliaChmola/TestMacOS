//
//  FolderViewController.swift
//  GlobalLogicTestApp
//
//  Created by Chmola Lilia on 11/7/19.
//  Copyright © 2019 Lilia Chmola. All rights reserved.
//

import Cocoa

class FolderViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var chooseButton: NSButton!
    @IBOutlet weak var shonJsonButton: NSButton!
    @IBOutlet var textView: NSTextView!
    var rootNode: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseButtonTapped(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path = result!.path
                textField.stringValue = path
                let createdDate = getStringCreatedDate(path: path)
                let name = (path as NSString).lastPathComponent
                let node = Folder.init(value: path, dateCreated: createdDate, name: name)
                fillNode(node: node)
                rootNode = node
            }
        } else {
            return
        }
    }
    
    @IBAction func showButtonTapped(_ sender: Any) {
        textView.string = rootNode?.convertToDict().dict2json() ?? ""
    }
    
    private func fillNode(node: Folder) {
        let fileManager = FileManager.default
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: node.path)

            for file in files {
                guard file != ".DS_Store" else { continue }
              
                let path = node.path + "/\(file)"
                let fileExtension = (file as NSString).pathExtension

                if fileExtension.isEmpty {
                    let createdDate = getStringCreatedDate(path: path)
                    let name = (path as NSString).lastPathComponent
                    let newNode = Folder.init(value: path, dateCreated: createdDate, name: name)
                    fillNode(node: newNode)
                    node.add(child: newNode)
                } else {
                    let size = getFileSize(path: path)
                    let name = file
                    let file = MyFile.init(size: "\(size) B", name: name, path: path)
                    node.addFile(file: file)
                }
            }
            
        } catch let error as NSError {
            print("Error while enumerating files \(node.path): \(error.localizedDescription)")
        }
    }
    
    private func getStringCreatedDate(path: String) -> String {
        var createdDate = Date()
      
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path) as [FileAttributeKey:Any]
            if let date = fileAttributes[FileAttributeKey.creationDate] as? Date {
                createdDate = date
            }
        } catch let theError {
            print("file not found \(theError)")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return dateFormatter.string(from: createdDate)
    }
    
    private func getFileSize(path: String) -> UInt64 {
        var size: UInt64 = 0
     
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path) as [FileAttributeKey:Any]
            let dictFileAttributes = fileAttributes as NSDictionary
            size = dictFileAttributes.fileSize()
        } catch let theError {
            print("file not found \(theError)")
        }
        
        return size
    }
}
