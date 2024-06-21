//
//  ObjCMethodTypeDecoder.swift
//
//
//  Created by p-x9 on 2024/06/22
//  
//

import Foundation

public enum ObjCMethodTypeDecoder {
    // ref: https://github.com/apple-oss-distributions/objc4/blob/01edf1705fbc3ff78a423cd21e03dfc21eb4d780/runtime/objc-typeencoding.mm#L171
    public static func decode(_ type: String) -> ObjCMethodType? {
        guard let node = ObjCTypeDecoder._decode(type),
              let returnType = node.decoded,
              var trailing = node.trailing else {
            return nil
        }

        if trailing.first == "+" { trailing.removeFirst() }

        // Stack Size
        guard let _stackSize = trailing.readInitialDigits(),
              let stackSize = Int(_stackSize) else {
            return nil
        }
        trailing.removeFirst(_stackSize.count)

        // self
        guard let node = ObjCTypeDecoder._decode(trailing),
              let selfType = node.decoded,
              var trailing = node.trailing else {
            return nil
        }
        guard let _selfOffset = trailing.readInitialDigits(),
              let selfOffset = Int(_selfOffset) else {
            return nil
        }
        trailing.removeFirst(_selfOffset.count)
        let selfInfo = ObjCMethodType.ArgumentInfo(
            type: selfType,
            offset: selfOffset
        )

        // arguments
        var arguments: [ObjCMethodType.ArgumentInfo] = []
        while !trailing.isEmpty {
            guard let node = ObjCTypeDecoder._decode(trailing),
                  let type = node.decoded,
                  var _trailing = node.trailing else {
                return nil
            }
            guard let _offset = _trailing.readInitialDigits(),
                  let offset = Int(_offset) else {
                return nil
            }
            _trailing.removeFirst(_offset.count)
            trailing = _trailing
            arguments.append(
                ObjCMethodType.ArgumentInfo(
                    type: type,
                    offset: offset
                )
            )
        }

        guard let selectorInfo = arguments.first else { return nil }
        if arguments.count == 1 { arguments = [] }
        else { arguments = Array(arguments[1...]) }

        return .init(
            returnType: returnType,
            stackSize: stackSize,
            selfInfo: selfInfo,
            selectorInfo: selectorInfo,
            argumentInfos: arguments
        )
    }
}
