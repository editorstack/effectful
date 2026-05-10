import Cocoa
import FlutterMacOS

public class EffectfulUpdaterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "effectful_updater", binaryMessenger: registrar.messenger)
    let instance = EffectfulUpdaterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "restartApp":
      restartApp()
      result(nil)
    case "getExecutablePath":
      result(Bundle.main.executablePath)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func restartApp() {
    let executablePath = Bundle.main.executablePath!
    let updateFolder = Bundle.main.bundlePath + "/Contents/update"
    do {
      try copyAndReplaceFiles(from: updateFolder, to: Bundle.main.bundlePath + "/Contents")
    } catch {
      print("EffectfulUpdater: Error updating files: \(error)")
      return
    }
    do {
      try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: executablePath)
      let process = Process()
      process.executableURL = URL(fileURLWithPath: executablePath)
      process.arguments = []
      try process.run()
    } catch {
      print("EffectfulUpdater: Error during restart: \(error)")
      return
    }
    NSApplication.shared.terminate(nil)
  }

  private func copyAndReplaceFiles(from sourcePath: String, to destinationPath: String) throws {
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(atPath: sourcePath)
    while let element = enumerator?.nextObject() as? String {
      let sourceItemPath = (sourcePath as NSString).appendingPathComponent(element)
      let destinationItemPath = (destinationPath as NSString).appendingPathComponent(element)
      var isDir: ObjCBool = false
      if fileManager.fileExists(atPath: sourceItemPath, isDirectory: &isDir) {
        if isDir.boolValue {
          if !fileManager.fileExists(atPath: destinationItemPath) {
            try fileManager.createDirectory(atPath: destinationItemPath, withIntermediateDirectories: true, attributes: nil)
          }
        } else {
          let attributes = try fileManager.attributesOfItem(atPath: sourceItemPath)
          if attributes[.type] as? FileAttributeType == .typeSymbolicLink {
            if fileManager.fileExists(atPath: destinationItemPath) { try fileManager.removeItem(atPath: destinationItemPath) }
            let target = try fileManager.destinationOfSymbolicLink(atPath: sourceItemPath)
            try fileManager.createSymbolicLink(atPath: destinationItemPath, withDestinationPath: target)
          } else {
            if fileManager.fileExists(atPath: destinationItemPath) {
              try fileManager.replaceItem(at: URL(fileURLWithPath: destinationItemPath), withItemAt: URL(fileURLWithPath: sourceItemPath), backupItemName: nil, options: [], resultingItemURL: nil)
            } else {
              try fileManager.copyItem(atPath: sourceItemPath, toPath: destinationItemPath)
            }
          }
        }
      }
    }
  }
}
