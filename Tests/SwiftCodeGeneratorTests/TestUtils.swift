//
//  TestUtils.swift
//  SwiftCodeGeneratorTests
//
//  Created by Usuario on 9/26/18.
//

import Foundation
import Files

class TestUtils {
  func createEmptyTestFolder(named name: String) throws -> Folder {
    // Creo a una carpeta temporal
    let fileSystem = FileSystem()
    let tempFolder = fileSystem.temporaryFolder
    let testFolder = try tempFolder.createSubfolderIfNeeded(withName: name)
    try testFolder.empty()
    return testFolder
  }
  
  func createTempFileWithContentAtFolder(_ folder: Folder, _ name: String, _ content: String) throws {
    // Me muevo a esa carpeta temporal
    let fileManager = FileManager.default
    fileManager.changeCurrentDirectoryPath(folder.path)
    
    // Creo un archivo con la estructura a probar y la meto en la carpeta temporal dentro de la carpeta /Resources
    let newFile = try folder.createFile(named: name)
    try newFile.write(string: content)
  }
  
  func simpleStructContent() -> String {
    return """
struct SimpleStruct {
  var stringVar: String
}
"""
  }
}
