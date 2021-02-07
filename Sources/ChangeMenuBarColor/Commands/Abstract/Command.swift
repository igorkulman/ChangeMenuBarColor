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

class Command {
    func createWallpaper(screen: NSScreen) -> NSImage? {
        fatalError("Override for each type")
    }

    var useAllDisplays: Bool {
        fatalError("Override for each type")
    }

    func run() {
        Log.info("Starting up\n")

        let screens: [NSScreen] = useAllDisplays ? NSScreen.screens : [NSScreen.main].compactMap({ $0 })

        guard !screens.isEmpty else {
            Log.error("Could not detect any screens")
            return
        }

        for (index, screen) in screens.enumerated() {
            guard let adjustedWallpaper = createWallpaper(screen: screen), let data = adjustedWallpaper.jpgData else {
                Log.error("Could not generate new wallpaper screen \(index)")
                continue
            }

            setWallpaper(screen: screen, wallpaper: data)
        }

        Log.info("\nAll done!")
    }

    func loadWallpaperImage(wallpaper: String?, screen: NSScreen) -> NSImage? {
        if let path = wallpaper {
            guard let wallpaper = NSImage(contentsOfFile: path) else {
                Log.error("Cannot read the provided wallpaper file as image. Check if the path is correct and if it is a valid image file")
                return nil
            }

            Log.debug("Loaded \(path) to be used as wallpaper image")
            return wallpaper
        }

        guard let path = NSWorkspace.shared.desktopImageURL(for: screen), let wallpaper = NSImage(contentsOf: path) else {
            Log.error("Cannot read the currently set macOS wallpaper. Try providing a specific wallpaper as a parameter instead.")
            return nil
        }

        Log.debug("Using currently set macOS wallpaper \(path)")

        return wallpaper
    }

    private func setWallpaper(screen: NSScreen, wallpaper: Data) {
        guard let supportFiles = try? Folder.library?.subfolder(at: "Application Support"), let workingDirectory = try? supportFiles.createSubfolderIfNeeded(at: "ChangeMenuBarColor") else {
            Log.error("Cannot access Application Support folder")
            return
        }

        do {
            let generatedWallpaperFile = workingDirectory.url.appendingPathComponent("/wallpaper-screen-adjusted-\(UUID().uuidString).jpg")
            try? FileManager.default.removeItem(at: generatedWallpaperFile)

            try wallpaper.write(to: generatedWallpaperFile)
            Log.debug("Created new wallpaper for the main screen in \(generatedWallpaperFile.absoluteString)")

            try NSWorkspace.shared.setDesktopImageURL(generatedWallpaperFile, for: screen, options: [:])
            Log.info("Wallpaper set")
        } catch {
            Log.error("Writing new wallpaper file failed with \(error.localizedDescription) for the main screen")
        }
    }
}
