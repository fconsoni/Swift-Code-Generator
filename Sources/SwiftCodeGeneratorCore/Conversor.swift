//
//  Conversor.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 20/09/2018.
//

import Foundation

class Conversor {
  
  func convert(_ structDesc: String) -> String {
    let structParser = StructParser()
    let copyGenerator = CopyGenerator()
    
    let copy = structParser.parse(structDesc)
      .map(copyGenerator.generateCopyForStruct)
      .getOrElse("")
    Log.success(copy)
    return copy
  }
}

