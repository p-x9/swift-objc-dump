//
//  ObjCMethodInfo.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation
import ObjCTypeDecodeKit

/// Structure for representing objc method information.
@dynamicMemberLookup
public struct ObjCMethodInfo {
    /// Name of the method
    public let name: String
    /// Encoded method type of the method
    public let typeEncoding: String
    /// A boolean value that indicates whatever the method is class method or not.
    public let isClassMethod: Bool
    
    /// Initializes a new instance of `ObjCMethodInfo`.
    /// - Parameters:
    ///   - name: Name of the method
    ///   - typeEncoding: Encoded method type of the method
    ///   - isClassMethod: A boolean value that indicates whatever the method is class method or not.
    public init(
        name: String,
        typeEncoding: String,
        isClassMethod: Bool
    ) {
        self.name = name
        self.typeEncoding = typeEncoding
        self.isClassMethod = isClassMethod
    }
    
    /// Initializes a new instance of `ObjCMethodInfo`.
    /// - Parameters:
    ///   - method: Method of the target for which information is to be obtained.
    ///   - isClassMethod: A boolean value that indicates whatever the method is class method or not.
    public init?(
        _ method: Method,
        isClassMethod: Bool
    ) {
        guard let _typeEncoding = method_getTypeEncoding(method) else {
            return nil
        }
        let _name = method_getName(method)
        self.init(
            name: NSStringFromSelector(_name),
            typeEncoding: String(cString: _typeEncoding),
            isClassMethod: isClassMethod
        )
    }
    
    /// Initializes a new instance of `ObjCMethodInfo`.
    /// - Parameters:
    ///   - description: Method description of the target for which information is to be obtained.
    ///   - isClassMethod: A boolean value that indicates whatever the method is class method or not.
    public init?(
        _ description: objc_method_description,
        isClassMethod: Bool
    ) {
        guard let _name = description.name,
              let _typeEncoding = description.types else {
            return nil
        }

        self.init(
            name: NSStringFromSelector(_name),
            typeEncoding: String(cString: _typeEncoding),
            isClassMethod: isClassMethod
        )
    }
}

extension ObjCMethodInfo {
    /// Method type of the method
    ///
    /// It includes the type of the arguments and the type of the return value.
    public var type: ObjCMethodType? {
        ObjCMethodTypeDecoder.decode(typeEncoding)
    }

    public subscript<V>(dynamicMember keyPath: KeyPath<ObjCMethodType, V>) -> V? {
        type?[keyPath: keyPath]
    }
}

extension ObjCMethodInfo {
    public var headerString: String {
        let prefix = isClassMethod ? "+" : "-"
        let type: ObjCMethodType? = self.type

        // return type
        let returnType = type?.returnType.decodedStringForArgument ?? "unknown"

        // arguments
        let numberOfArguments = name.filter({ $0 == ":" }).count
        guard numberOfArguments > 0 else {
            return "\(prefix) (\(returnType))\(name);"
        }

        let nameAndLabels = name.split(separator: ":")

        let argumentInfos = type?.argumentInfos ?? []
        let argumentTypes = argumentInfos.map(\.type.decodedStringForArgument)

        var result = "\(prefix) (\(returnType))"

        zip(nameAndLabels, argumentTypes).enumerated()
            .forEach { (i, nameWithType) in
                let (name, type) = nameWithType
                var entry = "\(name):(\(type))arg\(i)"
                if i != 0 { entry = " \(entry)" }
                result += entry
            }

        result += ";"

        return result
    }
}
