//
//  SolidColor.swift
//  ArgumentParser
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import SwiftHEXColors

struct SolidColor: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SolidColor",
        abstract: "Adds solid color rectangle"
    )

    @Argument(help: "Wallpaper to use")
    private var wallpaper: String

    @Argument(help: "HEX color to use for the menu bar")
    private var color: String

    func run() {
        guard let color: NSColor = NSColor(hexString: self.color) else {
            print("Invalid HEX color provided. Make sure it includes the '#' symbol, e.g: #FF0000")
            return
        }

        guard let wallpaper = NSImage(contentsOfFile: wallpaper) else {
            print("Cannot read the provided wallpaper file as image")
            return
        }

        guard !NSScreen.screens.isEmpty else {
            print("Cannot detect screens")
            return
        }

        var index = 0

        for screen in NSScreen.screens {
            index = index+1

            let screenSize = screen.frame.size
            let menuBarHeight = screenSize.height - screen.visibleFrame.height - screen.visibleFrame.origin.y

            guard let resizedWallapper = wallpaper.resized(to: screenSize) else {
                print("Cannot not resize provided wallpaper to screen size")
                return
            }

            guard let topImage = createSolidImage(color: color, width: screenSize.width, height: menuBarHeight) else {
                return
            }

            guard let combined = combineImages(baseImage: resizedWallapper, addedImage: topImage), let data = combined.jpgData else {
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
}

