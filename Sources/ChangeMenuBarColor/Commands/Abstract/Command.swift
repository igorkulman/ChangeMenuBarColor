//
//  Command.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import Rainbow
import SwiftHEXColors

class Command {
    func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage? {
        return nil
    }

    func run() {
        print("Starting up".green)
        print("Found \(NSScreen.screens.count) screens\n")

        var generatedImages: [String] = []
        var index = 0

        for screen in NSScreen.screens {
            index = index+1

            print("Processing screen \(index) of \(NSScreen.screens.count)")

            let screenSize = screen.frame.size
            let menuBarHeight = screenSize.height - screen.visibleFrame.height - screen.visibleFrame.origin.y

            guard let adjustedWallpaper = createWallpaper(screenSize: screenSize, menuBarHeight: menuBarHeight), let data = adjustedWallpaper.jpgData else {
                print("Could not generate new wallpaper for screen \(index)".red)
                continue
            }

            let workingDirectory = FileManager.default.currentDirectoryPath
            let adjustedWallpaperFile = workingDirectory.appending("/wallpaper-screen\(index)-adjusted.jpg")

            do {
                try data.write(to: URL(fileURLWithPath: adjustedWallpaperFile))
                generatedImages.append(adjustedWallpaperFile)
                print("Created new wallpaper for screen \(index)".blue)
            } catch {
                print("Writing new wallpaper file failed with \(error.localizedDescription) for screen \(index)".red)
            }
            print("\n")
        }

        print("All done!".green)
        print("Here is the list of generated wallpaper images:".green)
        for image in generatedImages {
            print("\(image)\n".blue)
        }
        print("Do not forget to set the generated wallpaper images as your desktop background!".yellow)
    }

    func loadWallpaperImage(wallpaper: String?) -> NSImage? {
        if let path = wallpaper {
            guard let wallpaper = NSImage(contentsOfFile: path) else {
                print("Cannot read the provided wallpaper file as image. Check if the path is correct and if it is a valid image file".red)
                return nil
            }

            print("Loaded \(path) to be used as wallpaper image")
            return wallpaper
        }

        guard let path = getCurrentWallpaperPath(), let wallpaper = NSImage(contentsOfFile: path) else {
            print("Cannot read the currently set macOS wallpaper".red)
            print("Try providing a specific wallpaper as a parameter instead".blue)
            return nil
        }

        print("Using currently set macOS wallpaper \(path)")

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

        do {
            try task.run()
        } catch {
            print("Trying to get the currenty set macOS wallpaper failed with \(error)")
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        return NSString(string: output).expandingTildeInPath
    }
}
