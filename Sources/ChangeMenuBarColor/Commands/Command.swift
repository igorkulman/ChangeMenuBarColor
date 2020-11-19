//
//  Command.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa
import SwiftHEXColors

protocol Command: ParsableCommand {
    func createWallpaper(screenSize: CGSize, menuBarHeight: CGFloat) -> NSImage?
    func process()
}

extension Command {

    func process() {
        var index = 0

        for screen in NSScreen.screens {
            index = index+1

            let screenSize = screen.frame.size
            let menuBarHeight = screenSize.height - screen.visibleFrame.height - screen.visibleFrame.origin.y

            guard let adjustedWallpaper = createWallpaper(screenSize: screenSize, menuBarHeight: menuBarHeight), let data = adjustedWallpaper.jpgData else {
                print("Could not generate new wallpaper")
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
