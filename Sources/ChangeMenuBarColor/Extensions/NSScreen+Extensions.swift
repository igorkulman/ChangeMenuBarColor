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
        let computedHeight = (frame.size.height - visibleFrame.height - visibleFrame.origin.y) * backingScaleFactor
        guard computedHeight > 0 else {
            Log.debug("Menu bar height computation is still not good, using approximation")
            return 25 * backingScaleFactor
        }

        return computedHeight
    }
}
