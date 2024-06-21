//
//  ObjCTypeCodable.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import Foundation

public typealias ObjCTypeCodable = ObjCTypeDecodable & ObjCTypeEncodable

public protocol ObjCTypeDecodable {
    func decoded(tab: String) -> String
}

public protocol ObjCTypeEncodable {
    func encoded() -> String
}
