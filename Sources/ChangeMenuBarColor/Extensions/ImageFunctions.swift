//
//  ChangeMenuBarColor+ImageManipulation.swift
//  ChangeMenuBarColor
//
//  Created by Igor Kulman on 19.11.2020.
//

#if canImport(Accessibility)
    import Accessibility
#endif
import Foundation
import Cocoa

func createGradientImage(startColor: NSColor, endColor: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        Log.error("Could not create graphical context for gradient image")
        return nil
    }

    context.drawLinearGradient(CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [startColor.cgColor, endColor.cgColor] as CFArray, locations: [0.0, 1.0])!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: width, y: 0), options: [])

    guard let composedImage = context.makeImage() else {
        Log.error("Could not create composed image for gradient image")
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func createSolidImage(color: NSColor, width: CGFloat, height: CGFloat) -> NSImage? {
    guard let context = createContext(width: width, height: height) else {
        Log.error("Could not create graphical context for solid color image")
        return nil
    }

    context.setFillColor(color.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    guard let composedImage = context.makeImage() else {
        Log.error("Could not create composed image for solid color image")
        return nil
    }

    return NSImage(cgImage: composedImage, size: CGSize(width: width, height: height))
}

func combineImages(baseImage: NSImage, addedImage: NSImage) -> NSImage? {
    // Create a high-quality representation context
    let width = baseImage.size.width
    let height = baseImage.size.height
    
    // Create bitmap representation with higher quality options
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(width),
        pixelsHigh: Int(height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .calibratedRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )
    
    rep?.size = NSSize(width: width, height: height)
    
    // Create drawing context
    NSGraphicsContext.saveGraphicsState()
    guard let rep = rep, let context = NSGraphicsContext(bitmapImageRep: rep) else {
        Log.error("Could not create graphics context when merging images")
        NSGraphicsContext.restoreGraphicsState()
        return nil
    }
    NSGraphicsContext.current = context
    
    // Draw the base image (wallpaper) at full quality
    baseImage.draw(in: NSRect(x: 0, y: 0, width: width, height: height),
                  from: NSRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height),
                  operation: .copy,
                  fraction: 1.0)
    
    // Determine proper menu bar height - use a reasonable default if needed
    let scaleFactor = NSScreen.main?.backingScaleFactor ?? 2.0
    let menuBarHeight = min(addedImage.size.height, 24 * scaleFactor)
    
    // Draw the menu bar portion with high quality
    addedImage.draw(in: NSRect(x: 0, y: height - menuBarHeight, width: width, height: menuBarHeight),
                   from: NSRect(x: 0, y: 0, width: addedImage.size.width, height: menuBarHeight),
                   operation: .sourceOver,
                   fraction: 1.0)
    
    NSGraphicsContext.restoreGraphicsState()
    
    // Create final image from the bitmap representation
    let finalImage = NSImage(size: NSSize(width: width, height: height))
    finalImage.addRepresentation(rep)
    
    return finalImage
}

func createContext(width: CGFloat, height: CGFloat) -> CGContext? {
    return CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
}

func colorName(_ color: NSColor) -> String {
    if #available(OSX 11.0, *) {
        return AXNameFromColor(color.cgColor)
    } else {
        return color.description
    }
}

func getOriginalWallpaper(for screen: NSScreen) -> NSImage? {
    let workspace = NSWorkspace.shared
    if let url = workspace.desktopImageURL(for: screen) {
        do {
            let imageData = try Data(contentsOf: url)
            if let image = NSImage(data: imageData) {
                Log.debug("Successfully loaded original wallpaper from \(url.path)")
                return image
            } else {
                Log.error("Failed to convert data to NSImage")
                return nil
            }
        } catch {
            Log.error("Failed to load original wallpaper: \(error)")
            return nil
        }
    } else {
        Log.error("Could not get desktop image URL")
        return nil
    }
}
