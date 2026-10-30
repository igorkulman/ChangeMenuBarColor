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

    // Menu bar height in points, or nil when it cannot be determined (e.g. auto-hidden menu bar or no menu bar on this display)
    private var measuredMenuBarHeight: CGFloat? {
        // Height difference between the top of the full frame and the top of the visible frame
        var heightInPoints = frame.maxY - visibleFrame.maxY

        // On displays with a notch the menu bar is taller and matches the top safe area inset
        if #available(macOS 12.0, *) {
            heightInPoints = max(heightInPoints, safeAreaInsets.top)
        }

        return heightInPoints > 0 && heightInPoints <= 60 ? heightInPoints : nil
    }

    var menuBarHeight: CGFloat {
        let heightInPoints: CGFloat
        if let measured = measuredMenuBarHeight {
            heightInPoints = measured
        } else {
            // Fall back to the primary screen's menu bar, or the standard height
            heightInPoints = NSScreen.screens.first?.measuredMenuBarHeight ?? 24
            Log.debug("Menu bar height could not be calculated for this screen, using \(heightInPoints) points")
        }

        let calculatedHeight = heightInPoints * backingScaleFactor
        Log.debug("Using calculated menu bar height: \(calculatedHeight)")
        return calculatedHeight
    }
}
