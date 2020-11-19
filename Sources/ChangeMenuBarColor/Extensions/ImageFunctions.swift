//
//  ChangeMenuBarColor+ImageManipulation.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

import Foundation
import Cocoa

func createGradientImage(startColor: NSColor, endColor: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        return nil
    }

    context.drawLinearGradient(CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [NSColor.red.cgColor, NSColor.blue.cgColor] as CFArray, locations: [0.0, 1.0])!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: width, y: 0), options: [])

    guard let composedImage = context.makeImage() else {
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func createSolidImage(color: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        return nil
    }

    context.setFillColor(color.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    guard let composedImage = context.makeImage() else {
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func combineImages(baseImage: NSImage, addedImage: NSImage) -> NSImage? {
    guard let context = createContext(width: baseImage.size.width, height: baseImage.size.height), let baseImageCGImage = baseImage.cgImage, let addedImageCGImage = addedImage.cgImage else {
        return nil
    }

    context.draw(baseImageCGImage, in: CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height))
    context.draw(addedImageCGImage, in: CGRect(x: 0, y: baseImage.size.height - addedImage.size.height, width: addedImage.size.width, height: addedImage.size.height))

    guard let composedImage = context.makeImage() else {
        return nil
    }

    return NSImage(cgImage: composedImage, size: baseImage.size)
}

func createContext(width: CGFloat, height: CGFloat) -> CGContext? {
    return CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 4 * Int(width), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
}
