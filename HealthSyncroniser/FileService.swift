//
//  FileService.swift
//  HealthSync
//
//  Created by Daniel Metzing on 16.04.19.
//  Copyright © 2019 Daniel Metzing. All rights reserved.
//

import Foundation

class FileService {
    
    private let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("health_entries.log")
    private let fileManager = FileManager.default
    
    init() {
        createLogFileIfNeeded()
    }
    
    private func createLogFileIfNeeded() {
        if !fileManager.fileExists(atPath: fileURL.path) {
            fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
    }
    
    func add(entry: String) {
        if let fileUpdater = try? FileHandle(forUpdating: fileURL) {
            fileUpdater.seekToEndOfFile()
            fileUpdater.write(entry.data(using: .utf8)!)
            fileUpdater.write("\n".data(using: .utf8)!)
            fileUpdater.closeFile()
        }
    }
}
