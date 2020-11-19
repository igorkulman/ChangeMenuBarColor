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

struct SolidColor: Command {
    static let configuration = CommandConfiguration(
        commandName: "SolidColor",
        abstract: "Adds solid color rectangle"
    )

    @Argument(help: "Wallpaper to use")
    private var wallpaper: String

    @Argument(help: "HEX color to use for the menu bar")
    private var color: String

    func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage? {
        guard let color: NSColor = NSColor(hexString: self.color) else {
            print("Invalid HEX color provided. Make sure it includes the '#' symbol, e.g: #FF0000")
            return nil
        }

        guard let wallpaper = NSImage(contentsOfFile: wallpaper) else {
            print("Cannot read the provided wallpaper file as image")
            return nil
        }

        guard !NSScreen.screens.isEmpty else {
            print("Cannot detect screens")
            return nil
        }

        guard let resizedWallapper = wallpaper.resized(to: screenSize) else {
            print("Cannot not resize provided wallpaper to screen size")
            return nil
        }

        guard let topImage = createSolidImage(color: color, width: screenSize.width, height: menuBarHeight) else {
            return nil
        }

        return combineImages(baseImage: resizedWallapper, addedImage: topImage)
    }

    func run() {
        process()
    }
}

