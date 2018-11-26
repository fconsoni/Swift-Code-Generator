//
//  CopyGenerator.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 22/09/2018.
//

import Foundation

class CopyGenerator {
  func generateCopyForStruct(_ s: StructDataType) -> String {
    let params = s.properties.map(generateParamForProperty).joined(separator: ", ")
    
    Log.info("Generating copy for '\(s.name)'")
    
    var copySourceCode = ""
    copySourceCode.append("func copy(\(params)) -> \(s.name) {\n")
    copySourceCode.append("  return \(s.name)(\n")
    copySourceCode.append(
      s.properties.map(constructAssignmentForProperty)
        .map(curry(StringUtils.indentWithSpaces)(4))
        .joined(separator: ",\n")
    )
    copySourceCode.append("\n")
    copySourceCode.append("  )\n")
    copySourceCode.append("}")
    
    return copySourceCode
  }
  
  private func generateParamForProperty(_ property: Property) -> String {
    return "\(property.name): \(property.typeName)? = nil"
  }
  
  private func constructAssignmentForProperty(_ property: Property) -> String {
    return "\(property.name): \(property.name).getOrElse(self.\(property.name))"
  }
}
