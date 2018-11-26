import Foundation
import Files
import Commandant

public enum SwiftCodeGeneratorResult {
  case codeGenerated(String)
  case fileNotFound(String)
  case unknownError(Error)
}

public final class SwiftCodeGenerator {
  private let arguments: [String]
  private let projectPath : String
  
  public init(arguments: [String] = CommandLine.arguments) {
    self.arguments = arguments
    projectPath = arguments.tail().first.getOrElse("")
  }
  
  public func run() -> SwiftCodeGeneratorResult {
    Log.info("Starting")
    Log.info("Searching config file at '\(self.projectPath)'")
    
    if existsConfigFile() {
      ConversorManager(projectPath: self.projectPath).startConversion()
      
      return Result(try File(path: projectPath))
        .flatMap(self.parse)
        .map(Conversor().convert)
        .fold(.fileNotFound(self.projectPath), { return SwiftCodeGeneratorResult.codeGenerated($0) })
      
    } else {
      Log.error("Cannot find 'copy-config.json' file at '\(self.projectPath)'")
      return .fileNotFound(self.projectPath)
    }
  }
  
  private func handleError(_ error: Error) -> SwiftCodeGeneratorResult {
    if error is FileSystem.Item.PathError {
      switch error as! FileSystem.Item.PathError {
      case .invalid(let path): return .fileNotFound(path)
      case .empty: return .fileNotFound("")
      }
    }
    
    if error is File.Error {
      switch error as! File.Error {
      case .readFailed: return .fileNotFound(projectPath)
      case .writeFailed: return .unknownError(error)
      }
    }
    
    return .unknownError(error)
  }
  
  private func parse(_ file: File) -> Result<String> {
    return Result(try file.readAsString())
  }
  
  private func existsConfigFile() -> Bool {
    let configFilePath = self.projectPath + "/copy-config.json"
    
    return Result(try File(path: configFilePath)).isSuccess()
  }
}
