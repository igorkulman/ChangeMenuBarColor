//
//  NSImage+Extensions.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 16.11.2020.
//

import Foundation
import Cocoa

extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect.init(origin: .zero, size: self.size)
        return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }

    func resized(to newSize: NSSize) -> NSImage? {
        if let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) {
            bitmapRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
            draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()

            let resizedImage = NSImage(size: newSize)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }

        return nil
    }

    var jpgData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }

        return bitmapImage.representation(using: .jpeg, properties: [:])
    }

    func addColoredRectangle(color: NSColor, imageSize: NSSize, rectangleHeight: CGFloat) -> NSImage? {
        guard let cgImage = self.cgImage else {
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
