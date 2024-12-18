//
//  ObjCTypeDecoder.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import Foundation

public enum ObjCTypeDecoder {

    public static func decode(_ type: String) -> ObjCType? {
        _decode(type)?.decoded
    }

    public static func _decode(_ type: String) -> Node? {
        guard let first = type.first else { return nil }

        switch first {
            // decode `id`
            // ref: https://github.com/gnustep/libobjc2/blob/2855d1771478e1e368fcfeb4d56aecbb4d9429ca/encoding2.c#L159
        case _ where type.starts(with: "@?"):
            var trailing = type
            trailing.removeFirst(2)

            if trailing.starts(with: "<") {
                guard let closingIndex = trailing.indexForMatchingBracket(
                    open: "<", close: ">"
                ) else { return nil }
                let startInex = trailing.index(trailing.startIndex, offsetBy: 1)
                let endIndex = trailing.index(trailing.startIndex, offsetBy: closingIndex)
                let content = String(trailing[startInex ..< endIndex]) // <content>
                guard let retNode = _decode(content),
                      let retType = retNode.decoded else {
                    return nil
                }
                guard var args = retNode.trailing else { return nil }
                guard args.starts(with: "@?") else { return nil }
                args.removeFirst(2)
                var argTypes: [ObjCType] = []
                while !args.isEmpty {
                    guard let node = _decode(args),
                          let argType = node.decoded else {
                        return nil
                    }
                    argTypes.append(argType)
                    if let trailing = node.trailing {
                        args = trailing
                    } else {
                        break
                    }
                }
                let trailing = trailing.trailing(after: endIndex)
                return .init(
                    decoded: .block(return: retType, args: argTypes),
                    trailing: trailing
                )
            }
            return .init(
                decoded: .block(return: nil, args: nil),
                trailing: trailing
            )

        case _ where type.starts(with: #"@""#):
            guard let closingIndex = type.indexForFirstMatchingQuote(
                openIndex: type.index(after: type.startIndex)
            ) else { return nil }
            let startIndex = type.index(type.startIndex, offsetBy: 2)
            let endIndex = type.index(type.startIndex, offsetBy: closingIndex)
            let name = String(type[startIndex ..< endIndex])

            let trailing = type.trailing(after: endIndex)
            return .init(decoded: .object(name: name), trailing: trailing)

        case _ where type.starts(with: "^?"):
            var trailing = type
            trailing.removeFirst(2)
            return .init(decoded: .functionPointer, trailing: trailing)

        case _ where simpleTypes.keys.contains(first):
            var trailing = type
            trailing.removeFirst()
            return .init(decoded: simpleTypes[first], trailing: trailing)

        case _ where modifiers.keys.contains(first):
            var content = type
            content.removeFirst()
            guard let modifier = modifiers[first],
                  let content = _decode(content),
                  let contentType = content.decoded else {
                return nil
            }
            return .init(
                decoded: .modified(modifier, type: contentType),
                trailing: content.trailing
            )

        case "b":
            var content = type
            content.removeFirst()

            guard let _length = content.readInitialDigits(),
                  let length = Int(_length) else {
                return nil
            }
            let trailing = type.trailing(
                after: type.index(type.startIndex, offsetBy: _length.count)
            )
            return .init(
                decoded: .bitField(width: length),
                trailing: trailing
            )

        case "[":
            return _decodeArray(type)
        case "^":
            return _decodePointer(type)
        case "(":
            return _decodeUnion(type)
        case "{":
            return _decodeStruct(type)

        default:
            break
        }
        return nil
    }
}

extension ObjCTypeDecoder {

    // MARK: - Pointer ^
    private static func _decodePointer(_ type: String) -> Node? {
        var content = type
        content.removeFirst() // ^

        guard let node = _decode(content),
              let contentType = node.decoded else {
            return nil
        }

        return .init(decoded: .pointer(type: contentType), trailing: node.trailing)
    }

    // MARK: - Bit Field b
    private static func _decodeBitField(_ type: String, name: String?) -> (field: ObjCField, trailing: String?)? {
        var content = type
        content.removeFirst() // b

        guard let _length = content.readInitialDigits(),
              let length = Int(_length) else {
            return nil
        }

        let endInex = content.index(content.startIndex, offsetBy: _length.count)
        let trailing = type.trailing(after: endInex)

        return (
            .init(type: .int, name: name, bitWidth: length),
            trailing
        )
    }

    // MARK: - Array []
    private static func _decodeArray(_ type: String) -> Node? {

        guard let closingIndex = type.indexForMatchingBracket(open: "[", close: "]") else {
            return nil
        }

        let startInex = type.index(type.startIndex, offsetBy: 1)
        let endIndex = type.index(type.startIndex, offsetBy: closingIndex)

        var content = String(type[startInex ..< endIndex]) // [content]

        let length = content.readInitialDigits()

        if let _length = length,
           let length = Int(_length) {
            content.removeFirst(_length.count)
            guard let node = _decode(content),
                  let contentType = node.decoded else {
                return nil
            }

            // TODO: `node.trailing` must be empty
            let trailing = type.trailing(after: endIndex)

            return .init(
                decoded: .array(type: contentType, size: length),
                trailing: trailing
            )
        }

        guard let node = _decode(content),
              let contentType = node.decoded else {
            return nil
        }

        // TODO: `node.trailing` must be empty
        let trailing = type.trailing(after: endIndex)

        return .init(
            decoded: .array(type: contentType, size: nil),
            trailing: trailing
        )
    }

    // MARK: - Union ()
    private static func _decodeUnion(_ type: String) -> Node? {
        return _decodeFields(type, for: .union)
    }

    // MARK: - Struct {}
    private static func _decodeStruct(_ type: String) -> Node? {
        return _decodeFields(type, for: .struct)
    }

    // MARK: - Union or Struct
    enum _TypeKind: String {
        case `struct`
        case union
    }

    private static func _decodeFields(_ type: String, for kind: _TypeKind) -> Node? {
        let open, close: Character
        switch kind {
        case .struct:
            open = "{"; close = "}"
        case .union:
            open = "("; close = ")"
        }

        guard let closingIndex = type.indexForMatchingBracket(open: open, close: close) else {
            return nil
        }

        let startInex = type.index(type.startIndex, offsetBy: 1)
        let endIndex = type.index(type.startIndex, offsetBy: closingIndex)

        let content = String(type[startInex ..< endIndex]) // (content)
        guard !content.isEmpty else { return nil }

        guard let equalIndex = content.firstIndex(of: "=") else {
            let trailing = type.trailing(after: endIndex)
            switch kind {
            case .struct:
                return .init(decoded: .struct(name: content, fields: nil), trailing: trailing)
            case .union:
                return .init(decoded: .union(name: content, fields: nil), trailing: trailing)
            }
        }

        var typeName: String? = String(content[content.startIndex ..< equalIndex])
        if typeName == "?" { typeName = nil }

        var _fields = String(content[content.index(equalIndex, offsetBy: 1) ..< content.endIndex])
        var fields: [ObjCField] = []

        var number = 0
        while !_fields.isEmpty {
            guard let (field, trailing) = _decodeField(_fields) else { break }
            fields.append(field)
            if let trailing {
                _fields = trailing
                number += 1
            } else {
                break
            }
        }

        let trailing = type.trailing(after: endIndex)

        switch kind {
        case .struct:
            return .init(
                decoded: .struct(name: typeName, fields: fields),
                trailing: trailing
            )
        case .union:
            return .init(
                decoded: .union(name: typeName, fields: fields),
                trailing: trailing)

        }
    }

    private static func _decodeField(_ type: String) -> (field: ObjCField, trailing: String?)? {
        guard let first = type.first else { return nil }
        switch first {
        case "b":
            return _decodeBitField(type, name: nil)
        case "\"":
            guard let closingIndex = type.indexForFirstMatchingQuote(
                openIndex: type.startIndex
            ) else { return nil }
            let startIndex = type.index(type.startIndex, offsetBy: 1)
            let endIndex = type.index(type.startIndex, offsetBy: closingIndex)
            let name = String(type[startIndex ..< endIndex])

            let contentType = String(type[type.index(after: endIndex) ..< type.endIndex])
            if contentType.starts(with: "b"),
               let (field, trailing) = _decodeBitField(contentType, name: name) {
                return (field, trailing)
            } else if let node = _decode(contentType),
                      let contentType = node.decoded {
                return (
                    .init(type: contentType, name: name),
                    node.trailing
                )
            } else { return nil }

        default:
            guard let node = _decode(type),
                  let decoded = node.decoded else {
                return nil
            }
            return (
                .init(type: decoded),
                node.trailing
            )
        }
    }
}
