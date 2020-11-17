import ArgumentParser
import Foundation
import Cocoa
import SwiftHEXColors

struct ChangeMenuBarColor: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ChangeMenuBarColor",
        abstract: "A Swift command-line tool to create a custom menu bar color by merging the color and given wallpaper"
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

            guard let adjustedWallaper = resizedWallapper.addColoredRectangle(color: color, imageSize: screenSize, rectangleHeight: menuBarHeight), let data = adjustedWallaper.jpgData else {
                print("Cannot add colored rectangle at the top of the wallapepr image")
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

ChangeMenuBarColor.main()
