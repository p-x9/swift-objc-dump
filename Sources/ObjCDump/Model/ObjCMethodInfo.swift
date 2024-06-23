//
//  ObjCMethodInfo.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation
import ObjCTypeDecodeKit

@dynamicMemberLookup
public struct ObjCMethodInfo {
    let name: String
    let typeEncoding: String
    let isClassMethod: Bool
}

extension ObjCMethodInfo {
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
