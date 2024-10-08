//
//  ObjCType.swift
//
//
//  Created by p-x9 on 2024/06/21
//
//

import Foundation

public indirect enum ObjCType: Equatable {
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
    case functionPointer

    case array(type: ObjCType, size: Int?)
    case pointer(type: ObjCType)

    case bitField(width: Int)

    case union(name: String?, fields: [ObjCField]?)
    case `struct`(name: String?, fields: [ObjCField]?)

    case modified(_ modifier: ObjCModifier, type: ObjCType)

    case other(String)
}

extension ObjCType: ObjCTypeDecodable {
    public func decoded(tab: String = "    ") -> String {
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
        case .functionPointer:
            return "void * /* function pointer */"
        case .array(let type, let size):
            if let size {
                return "\(type.decoded(tab: tab))[\(size)]"
            } else {
                return "\(type.decoded(tab: tab))[]"
            }
        case .pointer(let type):
            return "\(type.decoded(tab: tab)) *"
        case .bitField(let width):
            return "int x : \(width)"
        case .union(let name, let fields):
            guard let fields, !fields.isEmpty else {
                if let name {
                    return "union \(name)"
                } else {
                    return "union {}"
                }
            }
            let fieldDefs = fields
                .enumerated()
                .map {
                    $1.decoded(fallbackName: "x\($0)", tab: tab)
                        .components(separatedBy: .newlines)
                        .map { tab + $0 }
                        .joined(separator: "\n")
                }
                .joined(separator: "\n")
            if let name {
                return """
                union \(name) {
                \(fieldDefs)
                }
                """
            } else {
                return """
                union {
                \(fieldDefs)
                }
                """
            }
        case .struct(let name, let fields):
            guard let fields, !fields.isEmpty else {
                if let name {
                    return "struct \(name)"
                } else {
                    return "struct {}"
                }
            }
            let fieldDefs = fields
                .enumerated()
                .map {
                    $1.decoded(fallbackName: "x\($0)", tab: tab)
                        .components(separatedBy: .newlines)
                        .map { tab + $0 }
                        .joined(separator: "\n")
                }
                .joined(separator: "\n")
            if let name {
                return """
                struct \(name) {
                \(fieldDefs)
                }
                """
            } else {
                return """
                struct {
                \(fieldDefs)
                }
                """
            }
        case .modified(let modifier, let type):
            return "\(modifier.decoded(tab: tab)) \(type.decoded(tab: tab))"

        case .other(let string):
            return string
        }
    }
}

extension ObjCType: ObjCTypeEncodable {
    public func encoded() -> String {
        switch self {
        case .class: return "#"
        case .selector: return ":"
        case .char: return "c"
        case .uchar: return "C"
        case .short: return "s"
        case .ushort: return "S"
        case .int: return "i"
        case .uint: return "I"
        case .long: return "l"
        case .ulong: return "L"
        case .longLong: return "q"
        case .ulongLong: return "Q"
        case .int128: return "t"
        case .uint128: return "T"
        case .float: return "f"
        case .double: return "d"
        case .longDouble: return "D"
        case .bool: return "B"
        case .void: return "v"
        case .unknown: return "?"
        case .charPtr: return "*"
        case .atom: return "%"
        case .object(let name):
            if let name {
                return "@\"\(name)\""
            } else {
                return "@"
            }
        case .block: return "@?"
        case .functionPointer: return "^?"
        case .array(let type, let size):
            if let size {
                return "[\(size)\(type.encoded())]"
            } else {
                return "[\(type.encoded())]"
            }
        case .pointer(let type):
            return "^\(type.encoded())"
        case .bitField(let width):
            return "b\(width)"
        case .union(let name, let fields):
            guard let fields else {
                if let name { return "(\(name))" }
                else { return "()" }
            }
            let fieldDefs = fields.map({ $0.encoded() })
                .joined()
            if let name {
                return "(\(name)=\(fieldDefs))"
            } else {
                return "(?=\(fieldDefs))"
            }
        case .struct(let name, let fields):
            guard let fields else {
                if let name { return "{\(name)}" }
                else { return "{}" }
            }
            let fieldDefs = fields.map({ $0.encoded() })
                .joined()
            if let name {
                return "{\(name)=\(fieldDefs)}"
            } else {
                return "{?=\(fieldDefs)}"
            }
        case .modified(let modifier, let type):
            return "\(modifier.encoded())\(type.encoded())"

        case .other(let string):
            return string
        }
    }
}
