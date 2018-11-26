//
//  ConversorManagerTests.swift
//  SwiftCodeGeneratorTests
//
//  Created by Usuario on 9/26/18.
//

import Foundation
import XCTest
import Files
import SwiftyJSON
@testable import SwiftCodeGeneratorCore

class ConversorManagerTests: XCTestCase {
  var testFolder: Folder!
  let folderName = "ConversorManagerTests"
  
  override func setUp() {
    testFolder = try! TestUtils().createEmptyTestFolder(named: folderName)
  }
  
  func testThatReadsCorrectConfigFile() {
    try! TestUtils().createTempFileWithContentAtFolder(self.testFolder, "copy-config.json", createConfigContent())
    
    XCTAssertNoThrow(try ConversorManager(projectPath: testFolder.path).retrieveJsonFromConfigFile().get())
    XCTAssertTrue(try! !ConversorManager(projectPath: testFolder.path).retrieveJsonFromConfigFile().get().dictionary.isEmpty())
  }
  
  func testThatFailsIncorrectConfigFile() {
    try! TestUtils().createTempFileWithContentAtFolder(self.testFolder, "copy-config.json", createConfigContent().words().take(1).joined())
    
    XCTAssertTrue(try ConversorManager(projectPath: testFolder.path).retrieveJsonFromConfigFile().get().dictionary.isEmpty())
  }
  
  private func createConfigContent() -> String {
    return """
{
    "paths": [
        "\(testFolder.path)/SimpleStruct.swift"
    ]
}
"""
  }
}
