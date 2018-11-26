//
//  PropertyParser.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 22/09/2018.
//

import Foundation

class PropertyParser {
  func parse(_ line: String) -> Property? {
    guard isProperty(line) else {
      return nil
    }
    
    let isConstant = line.contains("let")
    
    var processedLine = line
    processedLine = StringUtils.sanitize("var")(processedLine)
    processedLine = StringUtils.sanitize("let")(processedLine)
    
    let nameAndType = processedLine.components(separatedBy: ":")
    guard nameAndType.count == 2 else {
      return nil
    }
    
    let propertyName = nameAndType[0].trim()
    let propertyTypeName = nameAndType[1].trim()
    return Property.init(name: propertyName, typeName: propertyTypeName, isConstant: isConstant)
  }
  
  private func isProperty(_ line: String) -> Bool {
    return StringUtils.startWith("var", line) || StringUtils.startWith("let", line)
  }
  
  func validPropertyOn(_ bodyLines: [String]) -> (String) -> Bool {
    let isGlobal = {(_ property: String) -> Bool in
      return !self.isInFunction(bodyLines, property) && !self.isCalculated(property)
    }
    
    return isGlobal
  }
  
  private func isInFunction(_ bodyLines: [String], _ parameterLine: String) -> Bool {
    let parameterIndex = Int(bodyLines.index(of: parameterLine).getOrElse(0))
    let fixedBodyLines = bodyLines.take(parameterIndex)
    
    return fixedBodyLines.filter{ $0.contains("{") }.count > fixedBodyLines.filter{ $0.contains("}") }.count
  }
  
  
  private func isCalculated(_ parameterLine: String) -> Bool {
    return StringUtils.finishWordWith(parameterLine, "}")
  }

}
