import Foundation
import XCTest
import Files
import SwiftCodeGeneratorCore

class SwiftCodeGeneratorTests: XCTestCase {
  var testFolder: Folder!
  
  override func setUp() {
    testFolder = try! TestUtils().createEmptyTestFolder(named: "SwiftCodeGeneratorTests")
  }
  
  func runCodeGeneratorWithArgs(_ args: [String]) -> SwiftCodeGeneratorResult {
    var arguments = [testFolder.path]
    arguments.append(contentsOf: args)
    
    let codeGenerator = SwiftCodeGenerator(arguments: arguments)
    return codeGenerator.run()
  }
  
  func testThatGeneratesCopyForASimpleStruct() throws {
    let filename = "SimpleStruct.swift"
    let content = """
struct SimpleStruct {
  var stringVar: String
}
"""
    let expectedCopy = """
func copy(stringVar: String? = nil) -> SimpleStruct {
  return SimpleStruct(
    stringVar: stringVar.getOrElse(self.stringVar)
  )
}
"""
    try TestUtils().createTempFileWithContentAtFolder(testFolder, filename, content)
    let result = runCodeGeneratorWithArgs([filename])
    switch result {
    case .codeGenerated(let generatedCode):
      XCTAssertEqual(generatedCode, expectedCopy)
    default:
      XCTFail()
    }
  }
  
  func testThatGeneratesCopyForAComplexStruct() throws {
    let filename = "ComplexStruct.swift"
    let content = """
struct ComplexStruct {
  var stringVar: String
  var intVar: Int
  let intLet: Int
  var customTypeVar: CustomType
}
"""
    let expectedCopy = """
func copy(stringVar: String? = nil, intVar: Int? = nil, intLet: Int? = nil, customTypeVar: CustomType? = nil) -> ComplexStruct {
  return ComplexStruct(
    stringVar: stringVar.getOrElse(self.stringVar),
    intVar: intVar.getOrElse(self.intVar),
    intLet: intLet.getOrElse(self.intLet),
    customTypeVar: customTypeVar.getOrElse(self.customTypeVar)
  )
}
"""
    try TestUtils().createTempFileWithContentAtFolder(testFolder, filename, content)
    let result = runCodeGeneratorWithArgs([filename])
    switch result {
    case .codeGenerated(let generatedCode):
      XCTAssertEqual(generatedCode, expectedCopy)
    default:
      XCTFail()
    }
  }
  
  
  func testThatGeneratesCopyForAStructWithOptional() throws {
    let filename = "StructWithOptional.swift"
    let content = """
struct StructWithOptional {
  var stringVar: String?
}
"""
    let expectedCopy = """
func copy(stringVar: String?? = nil) -> StructWithOptional {
  return StructWithOptional(
    stringVar: stringVar.getOrElse(self.stringVar)
  )
}
"""
    try TestUtils().createTempFileWithContentAtFolder(testFolder, filename, content)
    let result = runCodeGeneratorWithArgs([filename])
    switch result {
    case .codeGenerated(let generatedCode):
      XCTAssertEqual(generatedCode, expectedCopy)
    default:
      XCTFail()
    }
  }
  
  func testThatGeneratesCopyIgnoringPropertiesOnFunctions() throws {
    let filename = "SimpleStruct.swift"
    let content = """
struct SimpleStruct {
  var stringVar: String
  func fx(var: Int) -> String {
    let ignoreThisOne: Int = 10
    return "Pepe"
  }
}
"""
    let expectedCopy = """
func copy(stringVar: String? = nil) -> SimpleStruct {
  return SimpleStruct(
    stringVar: stringVar.getOrElse(self.stringVar)
  )
}
"""
    try TestUtils().createTempFileWithContentAtFolder(testFolder, filename, content)
    let result = runCodeGeneratorWithArgs([filename])
    switch result {
    case .codeGenerated(let generatedCode):
      XCTAssertEqual(generatedCode, expectedCopy)
    default:
      XCTFail()
    }
  }
  
  func testThatFailsIfFileDoesNotExists() throws {
    let filename = "NotExistingFile.swift"
    XCTAssertFalse(testFolder.containsFile(named: filename))
    
    let result = runCodeGeneratorWithArgs([filename])
    switch result {
    case .fileNotFound: XCTAssertTrue(true)
    default: XCTFail()
    }
  }
}
