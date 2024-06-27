//
//  ObjCProtocolInfo.swift
//
//
//  Created by p-x9 on 2024/06/26
//  
//

import Foundation

public struct ObjCProtocolInfo {
    public let name: String

    public let protocols: [ObjCProtocolInfo]

    public let classProperties: [ObjCPropertyInfo]
    public let properties: [ObjCPropertyInfo]
    public let classMethods: [ObjCMethodInfo]
    public let methods: [ObjCMethodInfo]

    public let optionalClassProperties: [ObjCPropertyInfo]
    public let optionalProperties: [ObjCPropertyInfo]
    public let optionalClassMethods: [ObjCMethodInfo]
    public let optionalMethods: [ObjCMethodInfo]

    public init(
        name: String,
        protocols: [ObjCProtocolInfo],
        classProperties: [ObjCPropertyInfo],
        properties: [ObjCPropertyInfo],
        classMethods: [ObjCMethodInfo],
        methods: [ObjCMethodInfo],
        optionalClassProperties: [ObjCPropertyInfo],
        optionalProperties: [ObjCPropertyInfo],
        optionalClassMethods: [ObjCMethodInfo],
        optionalMethods: [ObjCMethodInfo]
    ) {
        self.name = name
        self.protocols = protocols
        self.classProperties = classProperties
        self.properties = properties
        self.classMethods = classMethods
        self.methods = methods
        self.optionalClassProperties = optionalClassProperties
        self.optionalProperties = optionalProperties
        self.optionalClassMethods = optionalClassMethods
        self.optionalMethods = optionalMethods
    }

    public init(_ `protocol`: Protocol) {
        // Name
        let _name = protocol_getName(`protocol`)
        let name = String(cString: _name)

        self.init(
            name: name,
            protocols: Self.protocols(
                of: `protocol`
            ),
            classProperties: Self.properties(
                of: `protocol`,
                isRequired: true, isInstance: false
            ),
            properties:  Self.properties(
                of: `protocol`,
                isRequired: true, isInstance: true
            ),
            classMethods: Self.methods(
                of: `protocol`,
                isRequired: true, isInstance: false
            ),
            methods: Self.methods(
                of: `protocol`,
                isRequired: true, isInstance: true
            ),
            optionalClassProperties:  Self.properties(
                of: `protocol`,
                isRequired: false, isInstance: false
            ),
            optionalProperties:  Self.properties(
                of: `protocol`,
                isRequired: false,
                isInstance: true)
            ,
            optionalClassMethods: Self.methods(
                of: `protocol`,
                isRequired: false, isInstance: false
            ),
            optionalMethods: Self.methods(
                of: `protocol`,
                isRequired: false, isInstance: true
            )
        )
    }
}

extension ObjCProtocolInfo {
    public var headerString: String {
        var decl = "@protocol \(name)"
        if !protocols.isEmpty {
            let protocols = protocols.map(\.name)
                .joined(separator: ", ")
            decl += " <\(protocols)>"
        }

        var lines = [decl]

        if !classProperties.isEmpty ||
            !properties.isEmpty ||
            !classMethods.isEmpty ||
            !methods.isEmpty {
            lines += ["", "@required", ""]
        }

        if !classProperties.isEmpty {
            lines.append("")
            lines += classProperties.map(\.headerString)
        }
        if !properties.isEmpty {
            lines.append("")
            lines += properties.map(\.headerString)
        }

        if !classMethods.isEmpty {
            lines.append("")
            lines += classMethods.map(\.headerString)
        }
        if !methods.isEmpty {
            lines.append("")
            lines += methods.map(\.headerString)
        }

        if !optionalClassProperties.isEmpty ||
            !optionalProperties.isEmpty ||
            !optionalClassMethods.isEmpty ||
            !optionalMethods.isEmpty {
            lines += ["", "@optional", ""]
        }

        lines += optionalClassProperties.map(\.headerString)
        lines += optionalProperties.map(\.headerString)
        lines += optionalClassMethods.map(\.headerString)
        lines += optionalMethods.map(\.headerString)

        lines += ["", "@end"]

        return lines.joined(separator: "\n")
    }
}

extension ObjCProtocolInfo {
    public static func protocols(
        of `protocol`: Protocol
    ) -> [ObjCProtocolInfo] {
        var count: UInt32 = 0
        let start = protocol_copyProtocolList(`protocol`, &count)
        guard let start else { return [] }

        defer {
            free(.init(start))
        }
        return UnsafeBufferPointer(start: start, count: Int(count))
            .compactMap {
                ObjCProtocolInfo($0)
            }
    }

    public static func properties(
        of `protocol`: Protocol,
        isRequired: Bool,
        isInstance: Bool
    ) -> [ObjCPropertyInfo] {
        var count: UInt32 = 0
        let start = protocol_copyPropertyList2(`protocol`, &count, isRequired, isInstance)
        guard let start else { return [] }

        defer {
            free(.init(start))
        }
        return UnsafeBufferPointer(start: start, count: Int(count))
            .compactMap {
                ObjCPropertyInfo($0, isClassProperty: !isInstance)
            }
    }

    public static func methods(
        of `protocol`: Protocol,
        isRequired: Bool,
        isInstance: Bool
    ) -> [ObjCMethodInfo] {
        var count: UInt32 = 0
        let start = protocol_copyMethodDescriptionList(`protocol`, isRequired, isInstance, &count)
        guard let start else { return [] }

        defer {
            free(.init(start))
        }
        return UnsafeBufferPointer(start: start, count: Int(count))
            .compactMap {
                ObjCMethodInfo($0, isClassMethod: !isInstance)
            }
    }
}
