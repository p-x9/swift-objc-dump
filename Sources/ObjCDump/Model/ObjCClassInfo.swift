//
//  ObjCClassInfo.swift
//
//
//  Created by p-x9 on 2024/06/24
//  
//

import Foundation

/// Structure for representing objc class information.
public struct ObjCClassInfo {
    /// Name of the class
    public let name: String
    /// Version of the class
    public let version: Int32
    /// Name of the dynamic library the class originated from.
    public let imageName: String?

    /// Size of instances of the class.
    public let instanceSize: Int

    /// Super class name of the class
    public let superClassName: String?

    /// List of protocols to which the class conforms.
    public let protocols: [ObjCProtocolInfo]

    /// List of instance variables held by the class.
    public let ivars: [ObjCIvarInfo]

    /// List of class properties held by the class.
    public let classProperties: [ObjCPropertyInfo]
    /// List of instance properties held by the class.
    public let properties: [ObjCPropertyInfo]

    /// List of class methods held by the class.
    public let classMethods: [ObjCMethodInfo]
    /// List of instance methods held by the class.
    public let methods: [ObjCMethodInfo]

    
    /// Initializes a new instance of `ObjCClassInfo`.
    /// - Parameters:
    ///   - name: Name of the class
    ///   - version: Version of the class
    ///   - imageName: Name of the dynamic library the class originated from.
    ///   - instanceSize: Size of instances of the class.
    ///   - superClassName: Super class name of the class
    ///   - protocols: List of protocols to which the class conforms.
    ///   - ivars: List of instance variables held by the class.
    ///   - classProperties: List of class properties held by the class.
    ///   - properties: List of instance properties held by the class.
    ///   - classMethods: List of class methods held by the class.
    ///   - methods: List of instance methods held by the class.
    public init(
        name: String,
        version: Int32,
        imageName: String?,
        instanceSize: Int,
        superClassName: String?,
        protocols: [ObjCProtocolInfo],
        ivars: [ObjCIvarInfo],
        classProperties: [ObjCPropertyInfo],
        properties: [ObjCPropertyInfo],
        classMethods: [ObjCMethodInfo],
        methods: [ObjCMethodInfo]
    ) {
        self.name = name
        self.version = version
        self.imageName = imageName
        self.instanceSize = instanceSize
        self.superClassName = superClassName
        self.protocols = protocols
        self.ivars = ivars
        self.classProperties = classProperties
        self.properties = properties
        self.classMethods = classMethods
        self.methods = methods
    }
    
    /// Initializes a new instance of `ObjCClassInfo`.
    /// - Parameter cls: Class of the target for which information is to be obtained.
    public init(_ cls: AnyClass) {
        // Name
        let name = NSStringFromClass(cls)

        // Version
        let version = class_getVersion(cls)

        // imageName
        let _imageName = class_getImageName(cls)
        let imageName: String? = if let _imageName {
            String(cString: _imageName)
        } else { nil }

        // instance Size
        let instanceSize = class_getInstanceSize(cls)

        // super class
        let superCls: AnyClass? = class_getSuperclass(cls)
        let superClassName: String? = if let superCls {
            NSStringFromClass(superCls)
        } else { nil }

        self.init(
            name: name,
            version: version,
            imageName: imageName,
            instanceSize: instanceSize,
            superClassName: superClassName,
            protocols: Self.protocols(of: cls),
            ivars: Self.ivars(of: cls),
            classProperties: Self.properties(of: cls, isInstance: false),
            properties: Self.properties(of: cls, isInstance: true),
            classMethods: Self.methods(of: cls, isInstance: false),
            methods: Self.methods(of: cls, isInstance: true)
        )
    }
}

extension ObjCClassInfo {
    public var headerString: String {
        var decl = "@interface \(name)"
        if let superClassName {
            decl += " : \(superClassName)"
        }

        if !protocols.isEmpty {
            let protocols = protocols.map(\.name)
                .joined(separator: ", ")
            decl += " <\(protocols)>"
        }

        var lines = [decl]

        if !ivars.isEmpty {
            lines[0] += " {"
            lines += ivars
                .map(\.headerString)
                .map {
                    $0.components(separatedBy: .newlines)
                        .map { "    \($0)" }
                        .joined(separator: "\n")
                }
            lines.append("}")
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

        lines += ["", "@end"]

        return lines.joined(separator: "\n")
    }
}

extension ObjCClassInfo {
    public static func protocols(
        of cls: AnyClass
    ) -> [ObjCProtocolInfo] {
        var count: UInt32 = 0
        let start = class_copyProtocolList(cls, &count)
        guard let start else { return [] }

        defer {
            free(.init(start))
        }
        return UnsafeBufferPointer(start: start, count: Int(count))
            .compactMap {
                ObjCProtocolInfo($0)
            }
    }

    public static func ivars(
        of cls: AnyClass
    ) -> [ObjCIvarInfo] {
        var count: UInt32 = 0
        let start = class_copyIvarList(cls, &count)
        guard let start else { return [] }

        defer {
            free(.init(start))
        }
        return UnsafeBufferPointer(start: start, count: Int(count))
            .compactMap {
                ObjCIvarInfo($0)
            }
    }

    public static func properties(
        of cls: AnyClass,
        isInstance: Bool
    ) -> [ObjCPropertyInfo] {
        var cls: AnyClass = cls
        if !isInstance {
            cls = objc_getMetaClass(NSStringFromClass(cls)) as! AnyClass
        }

        var count: UInt32 = 0
        let start = class_copyPropertyList(cls, &count)
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
        of cls: AnyClass,
        isInstance: Bool
    ) -> [ObjCMethodInfo] {
        var cls: AnyClass = cls
        if !isInstance {
            cls = objc_getMetaClass(NSStringFromClass(cls)) as! AnyClass
        }

        var count: UInt32 = 0
        let start = class_copyMethodList(cls, &count)
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
