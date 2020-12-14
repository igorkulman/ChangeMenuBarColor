//
//  File.swift
//  
//
//  Created by Igor Kulman on 14.12.2020.
//

import Foundation
import Rainbow

final class Log {
    static func error(_ message: String) {
        print(message.red)
    }

    static func info(_ message: String) {
        print(message.green)
    }

    static func debug(_ message: String) {
        print(message)
    }
}
