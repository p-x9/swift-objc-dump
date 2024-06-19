//
//  ObjCTypeDecoder.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import Foundation

public enum ObjCTypeDecoder {

    public static func decoded(_ type: String) -> String? {
        _decoded(type)?.decoded
    }

    public static func _decoded(_ type: String) -> Node? {
        guard let first = type.first else { return nil }

        switch first {
        case _ where simpleTypes.keys.contains(first):
            var trailing = type
            trailing.removeFirst()
            return .init(decoded: simpleTypes[first], trailing: trailing)

        case _ where modifiers.keys.contains(first):
            var content = type
            content.removeFirst()
            guard let modifier = modifiers[first],
                  let content = _decoded(content),
                  let contentType = content.decoded else {
                return nil
            }
            return .init(
                decoded: "\(modifier) \(contentType)",
                trailing: content.trailing
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

    // MARK: - Pointer ^
    private static func _decodePointer(_ type: String) -> Node? {
        var content = type
        content.removeFirst() // ^

        guard let node = _decoded(content),
              let decodedContent = node.decoded else {
            return nil
        }

        return .init(decoded: "\(decodedContent) *", trailing: node.trailing)
    }

    // MARK: - Bit Field b
    private static func _decodeBitField(_ type: String, number: Int) -> (field: String, trailing: String?)? {
        var content = type
        content.removeFirst() // b

        guard let length = content.readInitialDigits() else {
            return nil
        }

        var trailing: String?
        let startInex = content.index(content.startIndex, offsetBy: length.count)
        if content.distance(from: startInex, to: content.endIndex) > 0 {
            trailing = String(content[startInex ..< content.endIndex])
        }
        return ("int x\(number) : \(length);", trailing)
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

        if let length {
            content.removeFirst(length.count)
            guard let node = _decoded(content),
                  let decodedContent = node.decoded else {
                return nil
            }

            // TODO: `node.trailing` must be empty
            var trailing: String?
            let startInex = type.index(startInex, offsetBy: length.count)
            if type.distance(from: startInex, to: type.endIndex) > 0 {
                trailing = String(type[startInex ..< type.endIndex])
            }
            return .init(decoded: "\(decodedContent)[\(length)]", trailing: trailing)
        }

        guard let node = _decoded(content),
              let decodedContent = node.decoded else {
            return nil
        }

        // TODO: `node.trailing` must be empty
        var trailing: String?
        if type.distance(from: endIndex, to: type.endIndex) > 0 {
            trailing = String(type[type.index(after: endIndex) ..< type.endIndex])
        }

        return .init(decoded: "\(decodedContent)[]", trailing: trailing)
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
        guard !content.isEmpty,
              let equalIndex = content.firstIndex(of: "=") else {
            return nil
        }

        var typeName = String(content[content.startIndex ..< equalIndex])
        if typeName == "?" { typeName = "" }

        var _fields = String(content[content.index(equalIndex, offsetBy: 1) ..< content.endIndex])
        var fields: [String] = []

        var number = 0
        while !_fields.isEmpty {
            guard let (field, trailing) = _decodeField(_fields, number: number) else { break }
            fields.append(field)
            if let trailing {
                _fields = trailing
                number += 1
            } else {
                break
            }
        }

        var trailing: String?
        if type.distance(from: endIndex, to: type.endIndex) > 0 {
            trailing = String(type[type.index(after: endIndex) ..< type.endIndex])
        }

        return .init(
            decoded: "\(kind.rawValue) \(typeName) { \(fields.joined(separator: " ")) }",
            trailing: trailing
        )
    }

    private static func _decodeField(_ type: String, number: Int) -> (field: String, trailing: String?)? {
        guard let first = type.first else { return nil }
        if first == "b" {
            return _decodeBitField(type, number: number)
        } else {
            guard let node = _decoded(type),
                  let decoded = node.decoded else {
                return nil
            }
            return ("\(decoded) x\(number);", node.trailing)
        }
    }
}
