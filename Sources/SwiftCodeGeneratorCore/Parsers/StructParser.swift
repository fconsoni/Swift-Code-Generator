//
//  StructParser.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 22/09/2018.
//

import Foundation

class StructParser {
  func parse(_ sourceCode: String) -> StructDataType? {
    let propertyParser = PropertyParser()
    
    let allLines = sourceCode.lines().map(String.trim).map(execute)
    
    let firstLine = allLines.take(1).map(String.words).flatMap(execute)
    let bodyLines = allLines.tail().map(StringUtils.sanitize("private"))
    
    let validPropertyInContext = propertyParser.validPropertyOn(bodyLines)
    
    let structName = getStructNameFrom(firstLine)
    let properties = bodyLines
      .filter(validPropertyInContext)
      .compactMap(propertyParser.parse)
    
    Log.info("Parsing '\(structName)'")
    
    return StructDataType.init(name: structName, properties: properties)
  }
  
  private func getStructNameFrom(_ lines: [String]) -> String {
    let name = lines.take(2).tail().first.getOrElse("CLASSNAME")
    
    if StringUtils.finishWordWith(name, ":") {
      return String(name.dropLast())
    }
    
    return name
  }

}
