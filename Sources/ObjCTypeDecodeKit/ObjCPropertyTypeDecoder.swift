//
//  ObjCPropertyTypeDecoder.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation

public enum ObjCPropertyTypeDecoder {
    public static func decode(_ type: String) -> [ObjCPropertyAttribute] {
        let _attributes = type.split(separator: ",").map { String($0) }
        var attributes: [ObjCPropertyAttribute] = []

        for _attribute in _attributes {
            guard let first = _attribute.first else {
                attributes.append(.other(_attribute))
                continue
            }
            switch first {
            case "T":
                var type = _attribute
                type.removeFirst()
                attributes.append(
                    .type(ObjCTypeDecoder.decode(type))
                )
            case "R": attributes.append(.readonly)
            case "C": attributes.append(.copy)
            case "&": attributes.append(.retain)
            case "N": attributes.append(.nonatomic)
            case "G":
                var name = _attribute
                name.removeFirst()
                attributes.append(
                    .getter(name: name)
                )
            case "S":
                var name = _attribute
                name.removeFirst()
                attributes.append(
                    .setter(name: name)
                )
            case "D": attributes.append(.dynamic)
            case "W": attributes.append(.weak)
            case "V":
                var name = _attribute
                name.removeFirst()
                attributes.append(
                    .ivar(name: name)
                )
            default:
                attributes.append(.other(_attribute))
            }
        }

        return attributes
    }
}
