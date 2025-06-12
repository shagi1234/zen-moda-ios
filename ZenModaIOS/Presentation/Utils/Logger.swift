//
//  Logger.swift
//  ZenModaIOS
//
//  Created by Shahruh on 13.06.2025.
//


import Foundation
import SwiftUI

extension View {
    // for views
    public func log(_ message: String, _ type: LogType = .DEBUG) {
        #if DEBUG
        print("\n-[\(Self.self)] - \(type): \(message)")
        #endif
    }
}


class Logger {
    private init() {}
    static let shared = Logger()
    
    // for classes
    public func log(_ cls : AnyClass,_ level : LogType = .DEBUG, message : String) {
        #if DEBUG
        print("\n-[\(cls)] - \(level): " + message)
        #endif
    }
    
    public func log(_ cls : AnyClass,level : LogType = .DEBUG, message : String) {
        #if DEBUG
        print("\n-[\(cls)] - \(level): " + message)
        #endif
    }
    public func log(_ cls : AnyClass, message : String) {
        #if DEBUG
        print("\n-[\(cls)] - \(LogType.DEBUG): " + message)
        #endif
    }
    
    
    // for structs
    public func log<T>(_ type: T.Type, _ level: LogType = .DEBUG, message: String) {
        #if DEBUG
        print("\n-[\(type)] - \(level): " + message)
        #endif
    }
    
    public func log<T>(_ type: T.Type,level: LogType = .DEBUG, message: String) {
        #if DEBUG
        print("\n-[\(type)] - \(level): " + message)
        #endif
    }
    public func log<T>(_ type: T.Type, message: String) {
        #if DEBUG
        print("\n-[\(type)] - \(LogType.DEBUG): " + message)
        #endif
    }
}

public enum LogType: String {
    case DEBUG = "DEBUG"
    case INFO = "INFO"
    case WARNING = "WARNING"
    case ERROR = "ERROR"
}
