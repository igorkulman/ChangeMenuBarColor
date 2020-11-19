//
//  Gradient.swift
//  ArgumentParser
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import SwiftHEXColors

struct Gradient: Command {
    static let configuration = CommandConfiguration(
        commandName: "Gradient",
        abstract: "Adds gradient rectangle"
    )

    @Argument(help: "Wallpaper to use")
    private var wallpaper: String

    @Argument(help: "HEX color to use for gradient start")
    private var startColor: String

    @Argument(help: "HEX color to use for gradient end")
    private var endColor: String

    func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage? {
        guard let startColor: NSColor = NSColor(hexString: self.startColor) else {
            print("Invalid HEX color provided as gradient start color. Make sure it includes the '#' symbol, e.g: #FF0000")
            return nil
        }

        guard let endColor: NSColor = NSColor(hexString: self.endColor) else {
            print("Invalid HEX color provided as gradient end color. Make sure it includes the '#' symbol, e.g: #FF0000")
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

        guard let topImage = createGradientImage(startColor: startColor, endColor: endColor, width: screenSize.width, height: menuBarHeight) else {
            return nil
        }

        return combineImages(baseImage: resizedWallapper, addedImage: topImage)
    }

    func run() {
        process()
    }
}


