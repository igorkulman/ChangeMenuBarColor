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

    var jpgData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            Log.error("Cannot create data from bitmap image")
            return nil
        }

        return bitmapImage.representation(using: .jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor : 1])
    }
    
    func copy(size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame = NSMakeRect(0, 0, size.width, size.height)
        
        // Get the best representation for the given size.
        guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        
        // Create an empty image with the given size.
        let img = NSImage(size: size)
        
        // Set the drawing context and make sure to remove the focus before returning.
        img.lockFocus()
        defer { img.unlockFocus() }
        
        // Draw the new image
        if rep.draw(in: frame) {
            return img
        }
        
        // Return nil in case something went wrong.
        return nil
    }
    
    func resizeWhileMaintainingAspectRatioToSize(size: NSSize) -> NSImage? {
        let newSize: NSSize
        
        let widthRatio  = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        
        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(self.size.width * widthRatio), height: floor(self.size.height * widthRatio))
        } else {
            newSize = NSSize(width: floor(self.size.width * heightRatio), height: floor(self.size.height * heightRatio))
        }
        
        return self.copy(size: newSize)
    }
    
    func crop(size: NSSize) -> NSImage? {
        // only resize when the size actually differs
        guard size != self.size else {
            return self
        }

        // Resize the current image, while preserving the aspect ratio.
        guard let resized = self.resizeWhileMaintainingAspectRatioToSize(size: size) else {
            return nil
        }

        // the image centering is needed only when the resized image does not exactly match the screen size
        guard resized.size != size else {
            return resized
        }

        // Get some points to center the cropping area.
        let x = floor((resized.size.width - size.width) / 2)
        let y = floor((resized.size.height - size.height) / 2)
        
        // Create the cropping frame.
        let frame = NSMakeRect(x, y, size.width, size.height)
        
        // Get the best representation of the image for the given cropping frame.
        guard let rep = resized.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        
        // Create a new image with the new size
        let img = NSImage(size: size)
        
        img.lockFocus()
        defer { img.unlockFocus() }
        
        if rep.draw(in: NSMakeRect(0, 0, size.width, size.height),
                    from: frame,
                    operation: NSCompositingOperation.copy,
                    fraction: 1.0,
                    respectFlipped: false,
                    hints: [:]) {
            // Return the cropped image.
            return img
        }
        
        // Return nil in case anything fails.
        return nil
    }

    // Images loaded from file sometimes do not report the size correctly, see https://stackoverflow.com/questions/9264051/nsimage-size-not-real-size-with-some-pictures
    // This can lead to artifacts produced by resizing operations
    func adjustSize() {
        // use the biggest sizes from all the representations https://stackoverflow.com/a/38523158/581164
        size = representations.reduce(size) { size, representation in
            return CGSize(width: max(size.width, CGFloat(representation.pixelsWide)), height: max(size.height, CGFloat(representation.pixelsHigh)))
        }
    }
}
