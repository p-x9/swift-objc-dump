//
//  ObjCType.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import Foundation

public indirect enum ObjCType {
    case `class`
    case selector

    case char
    case uchar

    case short
    case ushort

    case int
    case uint

    case long
    case ulong

    case longLong
    case ulongLong

    case int128
    case uint128

    case float
    case double
    case longDouble

    case bool
    case void
    case unknown

    case charPtr

    case atom

    case object(name: String?)
    case block

    case array(type: ObjCType, size: Int?)
    case pointer(type: ObjCType)

    case union(name: String?, fields: [ObjCField])
    case `struct`(name: String?, fields: [ObjCField])

    case modified(_ modifier: ObjCModifier, type: ObjCType)

    case other(String)
}

extension ObjCType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .class: return "Class"
        case .selector: return "SEL"
        case .char: return "char"
        case .uchar: return "unsigned char"
        case .short: return "short"
        case .ushort: return "unsigned short"
        case .int: return "int"
        case .uint: return "unsigned int"
        case .long: return "long"
        case .ulong: return "unsigned long"
        case .longLong: return "long long"
        case .ulongLong: return "unsigned long long"
        case .int128: return "__int128_t"
        case .uint128: return "__uint128_t"
        case .float: return "float"
        case .double: return "double"
        case .longDouble: return "long double"
        case .bool: return "BOOL"
        case .void: return "void"
        case .unknown: return "unknown"
        case .charPtr: return "char *"
        case .atom: return "atom"
        case .object(let name):
            if let name {
                return "\(name) *"
            } else {
                return "id"
            }
        case .block:
            return "id /* block */"
        case .array(let type, let size):
            if let size {
                return "\(type)[\(size)]"
            } else {
                return "\(type)[]"
            }
        case .pointer(let type):
            return "\(type) *"
        case .union(let name, let fields):
            let fields = fields
                .map {
                    "\($0)"
                        .components(separatedBy: .newlines)
                        .map { "    " + $0 }
                        .joined(separator: "\n")
                }
                .joined(separator: "\n")
            if let name {
                return """
                union \(name) {
                \(fields)
                }
                """
            } else {
                return """
                union {
                \(fields)
                }
                """
            }
        case .struct(let name, let fields):
            let fields = fields
                .map {
                    "\($0)"
                        .components(separatedBy: .newlines)
                        .map { "    " + $0 }
                        .joined(separator: "\n")
                }
                .joined(separator: "\n")
            if let name {
                return """
                struct \(name) {
                \(fields)
                }
                """
            } else {
                return """
                struct {
                \(fields)
                }
                """
            }
        case .modified(let modifier, let type):
            return "\(modifier.modifier) \(type)"

        case .other(let string):
            return string
        }
    }
}
