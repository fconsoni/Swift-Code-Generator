//
//  Log.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 20/09/2018.
//

import Foundation
import Rainbow

class Log {
  static func emptyLog(_ message: String) {
    print(message)
  }
  
  static func info(_ message: String) {
    print("[INFO]  -  \(message)")
  }
  
  static func success(_ message: String) {
    print("\("[SUCCESS]".green)  -  \(message)")
  }
  
  static func error(_ message: String) {
    print("\("[ERROR]".red)  -  \(message)")
  }
  
  static func warning(_ message: String) {
    print("\("[WARNING]".yellow)  -  \(message)")
  }
}
