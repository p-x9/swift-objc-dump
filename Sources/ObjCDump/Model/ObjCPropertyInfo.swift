//
//  ObjCPropertyInfo.swift
//
//
//  Created by p-x9 on 2024/06/24
//  
//

import Foundation
import ObjCTypeDecodeKit

/// Structure for representing objc property information.
public struct ObjCPropertyInfo {
    /// Name of the property
    public let name: String
    /// Attributes string of the property
    public let attributesString: String
    /// A boolean value that indicates whatever the property is class property or not.
    public let isClassProperty: Bool
    
    /// Initializes a new instance of `ObjCPropertyInfo`.
    /// - Parameters:
    ///   - name: Name of the property
    ///   - attributes: Attributes string of the property
    ///   - isClassProperty: A boolean value that indicates whatever the property is class property or not.
    public init(
        name: String,
        attributes: String,
        isClassProperty: Bool
    ) {
        self.name = name
        self.attributesString = attributes
        self.isClassProperty = isClassProperty
    }
    
    /// Initializes a new instance of `ObjCPropertyInfo`.
    /// - Parameters:
    ///   - property: Property of the target for which information is to be obtained.
    ///   - isClassProperty: A boolean value that indicates whatever the property is class property or not.
    public init?(
        _ property: objc_property_t,
        isClassProperty: Bool
    ) {
        guard let _attributes = property_getAttributes(property) else {
            return nil
        }
        let _name = property_getName(property)
        self.init(
            name: String(cString: _name),
            attributes: String(cString: _attributes),
            isClassProperty: isClassProperty
        )
    }
}

extension ObjCPropertyInfo {
    /// Attribute list of the property
    public var attributes: [ObjCPropertyAttribute] {
        ObjCPropertyTypeDecoder.decode(attributesString)
    }
}

extension ObjCPropertyInfo {
    public var headerString: String {
        let attributes = self.attributes
        // Type
        let type = attributes.compactMap {
            if case let .type(type) = $0, let type { return type }
            return nil
        }.first
        let typeString = type?.decodedStringForArgument ?? "unknown"

        // Attributes
        var _attributes: [String] = []
        // class
        if isClassProperty {
            _attributes.append("class")
        }

        // getter
        if let getter = attributes.compactMap({
            if case let .getter(name) = $0 { return name }
            return nil
        }).first {
            _attributes.append("getter=\(getter)")
        }
        // setter
        if let setter = attributes.compactMap({
            if case let .setter(name) = $0 { return name }
            return nil
        }).first {
            _attributes.append("setter=\(setter)")
        }

        // readonly
        if attributes.contains(.readonly) {
            _attributes.append("readonly")
        }

        // weak
        if attributes.contains(.weak) {
            _attributes.append("weak")
        }
        // copy
        if attributes.contains(.copy) {
            _attributes.append("copy")
        }
        // retain
        if attributes.contains(.retain) {
            _attributes.append("retain")
        }

        // nonatomic
        if attributes.contains(.nonatomic) {
            _attributes.append("nonatomic")
        }

        // Comments
        var comments: [String] = []
        if attributes.contains(.dynamic) {
            comments.append("@dynamic \(name)")
        }
        if let ivar = attributes.compactMap({
            if case let .ivar(name) = $0 { return name }
            return nil
        }).first {
            if ivar == name {
                comments.append("@synthesize \(ivar)")
            } else {
                comments.append("@synthesize \(name)=\(ivar)")
            }
        }

        var result = "@property"
        if !_attributes.isEmpty {
            result += "("
            result += _attributes.joined(separator: ", ")
            result += ")"
        }
        result += " \(typeString)"
        if typeString.last == "*" {
            result += "\(name);"
        } else {
            result += " \(name);"
        }
        if !comments.isEmpty {
            for comment in comments {
                result += " // \(comment)"
            }
        }

        return result
    }
}
