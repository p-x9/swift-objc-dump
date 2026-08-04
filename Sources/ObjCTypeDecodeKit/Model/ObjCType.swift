//
//  ObjCType.swift
//
//
//  Created by p-x9 on 2024/06/21
//
//

import Foundation

public indirect enum ObjCType: Sendable, Equatable {
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
    case block(return: ObjCType?, args: [ObjCType]?)
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
        decoded(declarator: "", tab: tab)
    }
}

extension ObjCType {
    /// Decodes the receiver as a C declarator containing `name`.
    ///
    /// The name is placed according to C's declarator grammar, so arrays and
    /// blocks are rendered correctly.
    public func decoded(
        declarator name: String,
        tab: String = "    "
    ) -> String {
        let components = declaratorComponents(name: name, tab: tab)
        guard !components.declarator.isEmpty else {
            return components.specifier
        }
        if components.declarator.first == "[" {
            return "\(components.specifier)\(components.declarator)"
        }
        return "\(components.specifier) \(components.declarator)"
    }
}

extension ObjCType {
    private func declaratorComponents(
        name: String,
        tab: String
    ) -> (specifier: String, declarator: String) {
        switch self {
        case .class:
            return ("Class", name)
        case .selector:
            return ("SEL", name)
        case .char:
            return ("char", name)
        case .uchar:
            return ("unsigned char", name)
        case .short:
            return ("short", name)
        case .ushort:
            return ("unsigned short", name)
        case .int:
            return ("int", name)
        case .uint:
            return ("unsigned int", name)
        case .long:
            return ("long", name)
        case .ulong:
            return ("unsigned long", name)
        case .longLong:
            return ("long long", name)
        case .ulongLong:
            return ("unsigned long long", name)
        case .int128:
            return ("__int128_t", name)
        case .uint128:
            return ("__uint128_t", name)
        case .float:
            return ("float", name)
        case .double:
            return ("double", name)
        case .longDouble:
            return ("long double", name)
        case .bool:
            return ("BOOL", name)
        case .void:
            return ("void", name)
        case .unknown:
            return ("unknown", name)
        case .atom:
            return ("atom", name)

        case .charPtr:
            return ("char", "*\(name)")

        case .object(let objectName):
            guard let objectName else {
                return ("id", name)
            }
            if objectName.first == "<" && objectName.last == ">" {
                return ("id \(objectName)", name)
            }
            return (objectName, "*\(name)")

        case .block(let returnType, let arguments):
            guard let returnType, let arguments else {
                return ("id /* block */", name)
            }
            let argumentList = arguments
                .map { $0.decoded(declarator: "", tab: tab) }
                .joined(separator: ", ")
            return (
                returnType.decoded(declarator: "", tab: tab),
                "(^\(name))(\(argumentList))"
            )

        case .functionPointer:
            return ("void", "*\(name) /* function pointer */")

        case .array(let type, let size):
            let suffix = size.map { "[\($0)]" } ?? "[]"
            return type.declaratorComponents(
                name: "\(name)\(suffix)",
                tab: tab
            )

        case .pointer(let type):
            let pointerName: String
            if case .array = type {
                pointerName = "(*\(name))"
            } else {
                pointerName = "*\(name)"
            }
            return type.declaratorComponents(name: pointerName, tab: tab)

        case .bitField(let width):
            return ("int", "\(name.isEmpty ? "x" : name) : \(width)")

        case .union(let typeName, let fields):
            return (
                aggregateSpecifier(
                    kind: "union",
                    name: typeName,
                    fields: fields,
                    tab: tab
                ),
                name
            )

        case .struct(let typeName, let fields):
            return (
                aggregateSpecifier(
                    kind: "struct",
                    name: typeName,
                    fields: fields,
                    tab: tab
                ),
                name
            )

        case .modified(let modifier, let type):
            let components = type.declaratorComponents(name: name, tab: tab)
            return (
                "\(modifier.decoded(tab: tab)) \(components.specifier)",
                components.declarator
            )

        case .other(let string):
            return (string, name)
        }
    }

    private func aggregateSpecifier(
        kind: String,
        name: String?,
        fields: [ObjCField]?,
        tab: String
    ) -> String {
        let typeName = name.map { " \($0)" } ?? ""
        guard let fields, !fields.isEmpty else {
            return name.map { "\(kind) \($0)" } ?? "\(kind) {}"
        }

        let fieldDeclarations = fields.enumerated().map { index, field in
            let fieldName = field.name ?? "x\(index)"
            var declaration = field.type.decoded(
                declarator: fieldName,
                tab: tab
            )
            if let bitWidth = field.bitWidth {
                declaration += " : \(bitWidth)"
            }
            return declaration
                .components(separatedBy: .newlines)
                .map { tab + $0 }
                .joined(separator: "\n") + ";"
        }.joined(separator: "\n")

        return """
        \(kind)\(typeName) {
        \(fieldDeclarations)
        }
        """
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
        case let .block(ret, args):
            guard let ret, let args else {
                return "@?"
            }
            let argTypes = args.map({ $0.encoded() }).joined()
            return "@?<\(ret.encoded())@?\(argTypes)>"
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
