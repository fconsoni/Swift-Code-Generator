//
//  Error.swift
//  SwiftCodeGeneratorCore
//
//  Created by Usuario on 9/25/18.
//

import Foundation

enum GeneratorError {
  case parseError
  case fileNotFound(String)
  case unknown(Error)
}
