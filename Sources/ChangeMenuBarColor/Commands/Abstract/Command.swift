//
//  Command.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Files
import Foundation
import Cocoa
import Rainbow
import SwiftHEXColors

class Command {
    func createWallpaper(screen: NSScreen) -> NSImage? {
        return nil
    }

    func run() {
        print("Starting up".green)
        print("Found \(NSScreen.screens.count) screens\n")

        for screen in NSScreen.screens {
            print("Processing screen \(screen.index) of \(NSScreen.screens.count)")

            guard let adjustedWallpaper = createWallpaper(screen: screen), let data = adjustedWallpaper.jpgData else {
                print("Could not generate new wallpaper for screen \(screen.index)".red)
                continue
            }

            setWallpaper(screen: screen, wallpaper: data)
        }

        print("All done!".green)
    }

    func loadWallpaperImage(wallpaper: String?, screen: NSScreen) -> NSImage? {
        if let path = wallpaper {
            guard let wallpaper = NSImage(contentsOfFile: path) else {
                print("Cannot read the provided wallpaper file as image. Check if the path is correct and if it is a valid image file".red)
                return nil
            }

            print("Loaded \(path) to be used as wallpaper image")
            return wallpaper
        }

        guard let path = NSWorkspace.shared.desktopImageURL(for: screen), let wallpaper = NSImage(contentsOf: path) else {
            print("Cannot read the currently set macOS wallpaper".red)
            print("Try providing a specific wallpaper as a parameter instead".blue)
            return nil
        }

        print("Using currently set macOS wallpaper \(path)")

        return wallpaper
    }

    private func setWallpaper(screen: NSScreen, wallpaper: Data) {
        guard let supportFiles = try? Folder.library?.subfolder(at: "Application Support"), let workingDirectory = try? supportFiles.createSubfolderIfNeeded(at: "ChangeMenuBarColor") else {
            print("Cannot access Application Support folder".red)
            return
        }

        do {
            let generatedWallpaperFile = workingDirectory.url.appendingPathComponent("/wallpaper-screen\(screen.index)-adjusted-\(UUID().uuidString).jpg")
            try? FileManager.default.removeItem(at: generatedWallpaperFile)

            try wallpaper.write(to: generatedWallpaperFile)
            print("Created new wallpaper for screen \(screen.index) in \(generatedWallpaperFile.absoluteString)")

            try NSWorkspace.shared.setDesktopImageURL(generatedWallpaperFile, for: screen, options: [:])
            print("Wallpper set".blue)
        } catch {
            print("Writing new wallpaper file failed with \(error.localizedDescription) for screen \(screen.index)".red)
        }
        print("\n")
    }
}
