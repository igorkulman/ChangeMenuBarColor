//
//  ChangeMenuBarColor+ImageManipulation.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import Foundation
import Cocoa
import Rainbow

func createGradientImage(startColor: NSColor, endColor: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        print("Could not create graphical context for gradient image".red)
        return nil
    }

    context.drawLinearGradient(CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [startColor.cgColor, endColor.cgColor] as CFArray, locations: [0.0, 1.0])!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: width, y: 0), options: [])

    guard let composedImage = context.makeImage() else {
        print("Could not create composed image for gradient image".red)
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func createSolidImage(color: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        print("Could not create graphical context for solid color image".red)
        return nil
    }

    context.setFillColor(color.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    guard let composedImage = context.makeImage() else {
        print("Could not create composed image for solid color image".red)
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func combineImages(baseImage: NSImage, addedImage: NSImage) -> NSImage? {
    guard let context = createContext(width: baseImage.size.width, height: baseImage.size.height) else {
        print("Could not create graphical context when merging images".red)
        return nil
    }

    guard let baseImageCGImage = baseImage.cgImage, let addedImageCGImage = addedImage.cgImage else {
        print("Could not create cgImage when merging images".red)
        return nil
    }

    context.draw(baseImageCGImage, in: CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height))
    context.draw(addedImageCGImage, in: CGRect(x: 0, y: baseImage.size.height - addedImage.size.height, width: addedImage.size.width, height: addedImage.size.height))

    guard let composedImage = context.makeImage() else {
        print("Could not create composed image when merging with the wallpaper".red)
        return nil
    }

    return NSImage(cgImage: composedImage, size: baseImage.size)
}

func createContext(width: CGFloat, height: CGFloat) -> CGContext? {
    return CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 4 * Int(width), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
}
