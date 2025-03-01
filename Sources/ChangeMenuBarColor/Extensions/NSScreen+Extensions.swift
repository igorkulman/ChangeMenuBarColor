//
//  File.swift
//  
//
//  Created by Igor Kulman on 21.11.2020.
//

import Foundation
import Cocoa

extension NSScreen {
    var size: CGSize {
        return CGSize(width: frame.size.width * backingScaleFactor, height: frame.size.height * backingScaleFactor)
    }

    var menuBarHeight: CGFloat {
        // Get the height difference between full frame and visible frame
        let calculatedHeight = (frame.size.height - visibleFrame.height - visibleFrame.origin.y) * backingScaleFactor
        
        // Apply safety limits - macOS menu bar is typically between 22-25 points
        if calculatedHeight <= 0 || calculatedHeight > 40 {
            Log.debug("Menu bar height calculation appears incorrect (\(calculatedHeight)), using standard height")
            return 24 * backingScaleFactor // Standard menu bar height
        }
        
        Log.debug("Using calculated menu bar height: \(calculatedHeight)")
        return calculatedHeight
    }
}
