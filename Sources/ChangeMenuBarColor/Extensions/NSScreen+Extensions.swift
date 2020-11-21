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
        return frame.size
    }

    var menuBarHeight: CGFloat {
        return size.height - visibleFrame.height - visibleFrame.origin.y
    }

    var index: Int {
        (NSScreen.screens.firstIndex(of: self) ?? 0) + 1
    }
}
