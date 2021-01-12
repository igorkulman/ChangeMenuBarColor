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
        return (frame.size.height - visibleFrame.height - visibleFrame.origin.y) * backingScaleFactor
    }
}
