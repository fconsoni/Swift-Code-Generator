//
//  StringUtils.swift
//  SwiftCodeGeneratorCore
//
//  Created by Leandro Linardos on 22/09/2018.
//

import Foundation

class StringUtils {
  static func indentWithSpaces(_ spaces: Int, _ source: String) -> String {
    return "\(String.init(repeating: " ", count: spaces))\(source)"
  }
  
  static func finishWordWith(_ word: String, _ char: Character) -> Bool {
    return word.reversed().take(1) == [char]
  }
  
  static func startWith(_ word: String, _ line: String) -> Bool {
    let words = line.words()
    return words.first.getOrElse("EMPTY").elementsEqual(word)
  }
  
  static func sanitize(_ word: String) -> (String) -> String {
    let removeFirstWordIfExists = {(line: String) -> String in
      if StringUtils.startWith(word, line) {
        let words = line.words()
        return words.tail().joined(separator: " ")
      } else {
        return line
      }
    }
    
    return removeFirstWordIfExists
  }
}
