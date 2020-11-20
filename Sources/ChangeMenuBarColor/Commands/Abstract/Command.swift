//
//  Command.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import SwiftHEXColors

class Command {
    func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage? {
        return nil
    }

    func run() {
        var index = 0

        for screen in NSScreen.screens {
            index = index+1

            let screenSize = screen.frame.size
            let menuBarHeight = screenSize.height - screen.visibleFrame.height - screen.visibleFrame.origin.y

            guard let adjustedWallpaper = createWallpaper(screenSize: screenSize, menuBarHeight: menuBarHeight), let data = adjustedWallpaper.jpgData else {
                print("Could not generate new wallpaper")
                return
            }

            let workingDirectory = FileManager.default.currentDirectoryPath
            let adjustedWallpaperFile = workingDirectory.appending("/wallpaper-screen\(index)-adjusted.jpg")

            do {
                try data.write(to: URL(fileURLWithPath: adjustedWallpaperFile))
                print("Created new wallpaper \(adjustedWallpaperFile)")
            } catch {
                print("Writing new wallpaper file failed with \(error.localizedDescription)")
            }
        }

        print("\nAll done!")
    }

    func loadWallpaperImage(wallpaper: String?) -> NSImage? {
        if let wallpaper = wallpaper {
            guard let wallpaper = NSImage(contentsOfFile: wallpaper) else {
                print("Cannot read the provided wallpaper file as image")
                return nil
            }

            return wallpaper
        }

        print("Using currently set wallpaper")
        guard let path = getCurrentWallpaperPath(), let wallpaper = NSImage(contentsOfFile: path) else {
            print("Cannot read macOS wallpaper")
            return nil
        }

        return wallpaper
    }

    private func getCurrentWallpaperPath() -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/sqlite3")
        task.arguments = ["-readonly",
                          FileManager.default.homeDirectoryForCurrentUser.path.appending("/Library/Application Support/Dock/desktoppicture.db"),
                          "SELECT * FROM data ORDER BY rowID DESC LIMIT 1;"
                         ]

        let outputPipe = Pipe()

        task.standardOutput = outputPipe

        try? task.run()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        return output.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
    }
}
