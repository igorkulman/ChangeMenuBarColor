//
//  SolidColor.swift
//  ArgumentParser
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa

final class SolidColor: Command, ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SolidColor",
        abstract: "Adds solid color rectangle"
    )

    @Argument(help: "HEX color to use for the menu bar")
    private var color: String

    @Argument(help: "Wallpaper to use. If not provided the current macOS wallpaper will be used")
    private var wallpaper: String?

    @Flag(help: "Flag to set wallpaper for all displays not just the main display")
    private var allDisplays: Bool = false

    override var useAllDisplays: Bool {
        return allDisplays
    }

    override func createWallpaper(screen: NSScreen) -> NSImage? {
        guard let wallpaper = loadWallpaperImage(wallpaper: wallpaper, screen: screen) else {
            return nil
        }

        guard let color: NSColor = NSColor(hexString: self.color) else {
            Log.error("Invalid HEX color provided. Make sure it includes the '#' symbol, e.g: #FF0000")
            return nil
        }

        guard let resizedWallpaper = wallpaper.crop(size: screen.size) else {
            Log.error("Cannot not resize provided wallpaper to screen size")
            return nil
        }

        Log.debug("Generating \(colorName(color)) solid color image")
        guard let topImage = createSolidImage(color: color, width: screen.size.width, height: screen.menuBarHeight) else {
            return nil
        }

        return combineImages(baseImage: resizedWallpaper, addedImage: topImage)
    }
}

