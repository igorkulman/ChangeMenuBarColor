//
//  Gradient.swift
//  ArgumentParser
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import Rainbow
import SwiftHEXColors

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

    override func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage? {        
        guard let wallpaper = loadWallpaperImage(wallpaper: wallpaper) else {
            return nil
        }

        guard let startColor: NSColor = NSColor(hexString: self.startColor) else {
            print("Invalid HEX color provided as gradient start color. Make sure it includes the '#' symbol, e.g: #FF0000".red)
            return nil
        }

        guard let endColor: NSColor = NSColor(hexString: self.endColor) else {
            print("Invalid HEX color provided as gradient end color. Make sure it includes the '#' symbol, e.g: #FF0000".red)
            return nil
        }

        guard let resizedWallpaper = wallpaper.resized(to: screenSize) else {
            print("Cannot not resize provided wallpaper to screen size".red)
            return nil
        }

        print("Generating gradient image")
        guard let topImage = createGradientImage(startColor: startColor, endColor: endColor, width: screenSize.width, height: menuBarHeight) else {
            return nil
        }

        return combineImages(baseImage: resizedWallpaper, addedImage: topImage)
    }
}


