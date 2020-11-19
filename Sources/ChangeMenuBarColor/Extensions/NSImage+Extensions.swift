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
        guard let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            return nil
        }

        bitmapRep.size = newSize
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
        draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()

        let resizedImage = NSImage(size: newSize)
        resizedImage.addRepresentation(bitmapRep)
        return resizedImage
    }

    var jpgData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }

        return bitmapImage.representation(using: .jpeg, properties: [:])
    }    
}
