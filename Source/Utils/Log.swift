//
//  Log.swift
//  LunMap
//
//  Created by Yevhen Pyvovarov on 7/8/20.
//  Copyright © 2020 Yevhen Pyvovarov. All rights reserved.
//

import Foundation

/// Class used for logging
public enum Log {
    /// Log with DEBUG level
    ///
    /// - Parameters:
    ///   - closure: fake closure to caprute loging details
    ///   - functionName: functionName
    ///   - file: file
    ///   - line: line
    public static func debug(_ closure: @autoclosure () -> String,
                             functionName: String = #function,
                             file: String = #file,
                             line: UInt = #line) {
        #if DEBUG
        self.log("<DEBUG>: \(closure())", functionName: functionName, file: file, line: line)
        #endif
    }

    /// Log with ERROR level
    ///
    /// - Parameters:
    ///   - closure: fake closure to caprute loging details
    ///   - functionName: functionName
    ///   - file: file
    ///   - line: line
    public static func error(_ error: Error,
                             message closure: @autoclosure () -> String,
                             functionName: String = #function,
                             file: String = #file,
                             line: UInt = #line) {
        self.log("<ERROR>: \(error.localizedDescription), message: \(closure())",
                 functionName: functionName,
                 file: file,
                 line: line)
    }

    private static func log(_ closure: @autoclosure () -> String,
                            functionName: String = #function,
                            file: String = #file,
                            line: UInt = #line) {
        let str = "LUN_LOG: \(functionName) : \(closure())"

        Log.writeInLog(str)
    }

    private static func writeInLog(_ message: String) {
        NSLogv("%@", getVaList([message]))
    }
}
