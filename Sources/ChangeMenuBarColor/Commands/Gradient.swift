//
//  Gradient.swift
//  ArgumentParser
//
//  Created by Igor Kulman on 19.11.2020.
//

import Accessibility
import ArgumentParser
import Foundation
import Cocoa

final class Gradient: Command, ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "Gradient",
        abstract: "Adds gradient rectangle"
    )

    @Argument(help: "HEX color to use for gradient start")
    private var startColor: String

    @Argument(help: "HEX color to use for gradient end")
    private var endColor: String

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

        guard let startColor: NSColor = NSColor(hexString: self.startColor) else {
            Log.error("Invalid HEX color provided as gradient start color. Make sure it includes the '#' symbol, e.g: #FF0000")
            return nil
        }

        guard let endColor: NSColor = NSColor(hexString: self.endColor) else {
            Log.error("Invalid HEX color provided as gradient end color. Make sure it includes the '#' symbol, e.g: #FF0000")
            return nil
        }

        guard let resizedWallpaper = wallpaper.crop(size: screen.size) else {
            Log.error("Cannot not resize provided wallpaper to screen size")
            return nil
        }

        Log.debug("Generating gradient image from \(colorName(startColor)) to \(colorName(endColor))")
        guard let topImage = createGradientImage(startColor: startColor, endColor: endColor, width: screen.size.width, height: screen.menuBarHeight) else {
            return nil
        }

        return combineImages(baseImage: resizedWallpaper, addedImage: topImage)
    }
}


