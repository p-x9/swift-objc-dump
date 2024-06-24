//
//  ObjCPropertyAttribute.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation

// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW1
public enum ObjCPropertyAttribute: Equatable {
    case type(ObjCType?) // T
    case readonly // R
    case copy // C
    case retain // &
    case nonatomic // N
    case getter(name: String) // G
    case setter(name: String) // S
    case dynamic // D
    case weak // W
    case ivar(name: String) // V
//    case p // P The property is eligible for garbage collection.
//    case t // t Specifies the type using old-style encoding.
    case other(String)
}

extension ObjCPropertyAttribute: ObjCTypeEncodable {
    public func encoded() -> String {
        switch self {
        case .type(let type):
            if let type {
                "T\(type.encoded())"
            } else {
                "T"
            }
        case .readonly: "R"
        case .copy: "C"
        case .retain: "&"
        case .nonatomic: "N"
        case .getter(let name): "G\(name)"
        case .setter(let name): "S\(name)"
        case .dynamic: "D"
        case .weak: "W"
        case .ivar(let name): "V\(name)"
        case .other(let string): "\(string)"
        }
    }
}
