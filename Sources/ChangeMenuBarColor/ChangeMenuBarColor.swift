//
//  ChangeMenuBarColor.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import ArgumentParser
import Foundation
import Cocoa

struct ChangeMenuBarColor: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ChangeMenuBarColor",
        abstract: "A Swift command-line tool to create a custom menu bar color wallpaper for macOS Big Sur",
        subcommands: [SolidColor.self, Gradient.self]
    )
}
