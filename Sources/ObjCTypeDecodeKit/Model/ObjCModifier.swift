//
//  ObjCModifier.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import Foundation

public enum ObjCModifier: CaseIterable, Equatable {
    case complex
    case atomic
    case const
    case `in`
    case `inout`
    case out
    case bycopy
    case byref
    case oneway
    case register
}

extension ObjCModifier: ObjCTypeEncodable {
    public func encoded() -> String {
        switch self {
        case .complex: "j" // #include <complex.h>
        case .atomic: "A" // #include <stdatomic.h>
        case .const: "r"
        case .in: "n"
        case .inout: "N"
        case .out: "o"
        case .bycopy: "O"
        case .byref: "R"
        case .oneway: "V"
        case .register: "+" // FIXME: ????
        }
    }
}

extension ObjCModifier: ObjCTypeDecodable {
    public func decoded(tab: String = "    ") -> String {
        switch self {
        case .complex: "_Complex" // #include <complex.h>
        case .atomic: "_Atomic" // #include <stdatomic.h>
        case .const: "const"
        case .in: "in"
        case .inout: "inout"
        case .out: "out"
        case .bycopy: "bycopy"
        case .byref: "byref"
        case .oneway: "oneway"
        case .register: "register" // FIXME: ????
        }
    }
}
