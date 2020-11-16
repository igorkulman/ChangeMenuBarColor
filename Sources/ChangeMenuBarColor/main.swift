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
            print("Invalid HEX color provided")
            return
        }

        guard let wallpaper = NSImage(contentsOfFile: wallpaper) else {
            print("Cannot read the provided wallpaper file as image")
            return
        }

        guard let mainScreen = NSScreen.main else {
            print("Cannot get main screen")
            return
        }

        let screenSize = mainScreen.frame.size
        let menuBarHeight = screenSize.height - mainScreen.visibleFrame.height - mainScreen.visibleFrame.origin.y

        guard let resizedWallapper = wallpaper.resized(to: screenSize) else {
            print("Cannot not resize provided wallpaper to screen size")
            return
        }

        guard let adjustedWallaper = addColoredRectangle(image: resizedWallapper, color: color, imageSize: screenSize, rectangleHeight: menuBarHeight), let data = adjustedWallaper.jpgData else {
            print("Cannot add colored rectangle at the top of the wallapepr image")
            return
        }

        let workingDirectory = FileManager.default.currentDirectoryPath
        let adjustedWallpaperFile = workingDirectory.appending("/wallpaper-adjusted.jpg")

        do {
            try data.write(to: URL(fileURLWithPath: adjustedWallpaperFile))
        } catch {
            print("Writing new wallpaper file failed with \(error.localizedDescription)")
        }

        print("All done! Check out wallpaper-adjusted.jpg.")
    }

    private func addColoredRectangle(image: NSImage, color: NSColor, imageSize: NSSize, rectangleHeight: CGFloat) -> NSImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        guard let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(imageSize.width), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: imageSize.height - rectangleHeight, width: imageSize.width, height: rectangleHeight))

        guard let composedImage = context.makeImage() else {
            return nil
        }

        return NSImage(cgImage: composedImage, size: imageSize)
    }
}

ChangeMenuBarColor.main()
