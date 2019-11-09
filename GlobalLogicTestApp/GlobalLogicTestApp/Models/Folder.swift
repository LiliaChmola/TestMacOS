//
//  Folder.swift
//  GlobalLogicTestApp
//
//  Created by Chmola Lilia on 11/7/19.
//  Copyright © 2019 Lilia Chmola. All rights reserved.
//

import Foundation

class Folder {
    var path: String
    var name: String
    var dateCreated: String
    var children: [Folder] = []
    var files: [MyFile] = []
    weak var parent: Folder?
    
    init(value: String, dateCreated: String, name: String) {
        self.path = value
        self.dateCreated = dateCreated
        self.name = name
    }
    
    func add(child: Folder) {
        children.append(child)
        child.parent = self
    }
    
    func addFile(file: MyFile) {
        files.append(file)
    }
    
    func convertToDict() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["Name"] = name
        dict["DateCreated"] = dateCreated
        
        var filesDictArray = [[String: Any]]()
        for file in files {
            filesDictArray.append(file.convertToDict())
        }
        dict["Files"] = filesDictArray
        
        var childrenDictArray = [[String: Any]]()
        for child in children {
            childrenDictArray.append(child.convertToDict())
        }
        dict["children"] = childrenDictArray
                
        return dict
    }
}

struct MyFile {
    let size: String
    let name: String
    let path: String
    
    func convertToDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["Name"] = name
        dict["Size"] = size
        dict["Path"] = path
        return dict
    }
}
