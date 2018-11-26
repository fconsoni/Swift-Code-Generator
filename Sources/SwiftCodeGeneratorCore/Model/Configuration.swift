//
//  Configuration.swift
//  SwiftCodeGeneratorCore
//
//  Created by Usuario on 9/26/18.
//

import Foundation

struct Config {
  let path: String
  let entitiePaths: [String]
  
  func copy(path: String? = nil, entitiePaths: [String]? = nil) -> Config {
    return Config(path: path.getOrElse(self.path),
                  entitiePaths: entitiePaths.getOrElse(self.entitiePaths)
    )
  }
}
