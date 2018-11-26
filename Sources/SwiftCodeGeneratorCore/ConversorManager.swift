//
//  ConfigFileParser.swift
//  SwiftCodeGeneratorCore
//
//  Created by Usuario on 9/25/18.
//

import Foundation
import Files
import SwiftyJSON

class ConversorManager {
  private var configData: Config
  
  init(projectPath path: String) {
    self.configData = Config(path: path + "/copy-config.json", entitiePaths: [])
  }
  
  func startConversion() -> SwiftCodeGeneratorResult {
    Log.info("Reading config file")
    return self.readConfigFile()
  }
  
  private func readConfigFile() -> SwiftCodeGeneratorResult{
    //self.retrieveJsonFromConfigFile().fold(Log.error("Invalid config file format"), self.parse)
      //esto anda, y esta bien conceptualmente. Es un ejemplo de un fold de un result
    
    switch self.retrieveJsonFromConfigFile() {
    case .success(let json):
      self.parse(json)
      return .codeGenerated("")
    case .failure:
      Log.error("Invalid config file format")
      return .fileNotFound(configData.path)
    }
  }
  
  func retrieveJsonFromConfigFile() -> Result<JSON> {
    return readFileIn(configData.path).map(JSON.init(parseJSON:))
  }
  
  private func parse(_ json: JSON) {
    self.configData = self.configData.copy(entitiePaths: getPathsFrom(json))
    Log.info("Config file readed")
    
    self.configData.entitiePaths.forEach(generateCopyMethod)
    
  }
  
  private func generateCopyMethod(_ path: String) {
    switch readFileIn(path) {
    case .success(let content):
      _ = Conversor().convert(content)
    case .failure:
      Log.error("Invalid or inexistent file at '\(path)'")
    }
  }
  
  
  
  private func getPathsFrom(_ json: JSON) -> [String] {
    let uncastedPaths = get("paths", from: json).fold([], { $0.array.getOrElse([]) })
    
    return uncastedPaths.map(String.init)
  }
  
  private func get(_ key: String, from json: JSON) -> JSON? {
    return json.dictionary.getOrElse([:])[key]
  }
  
  private func readFileIn(_ path: String) -> Result<String> {
    return Result(try File(path: path).readAsString())
  }
}
