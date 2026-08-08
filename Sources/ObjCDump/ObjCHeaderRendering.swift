//
//  ObjCHeaderRendering.swift
//

import Foundation

enum ObjCHeaderRendering {
    static func unknownTypeDeclaration(
        declarator name: String = "",
        encoding: String? = nil
    ) -> String {
        let encodingComment = encoding.map {
            ": \(escapedEncoding($0))"
        } ?? ""
        return "void *\(name) /* unknown\(encodingComment) */"
    }

    static func unknownMethodEncodingComment(_ encoding: String) -> String {
        " /* unknown method encoding: \(escapedEncoding(encoding)) */"
    }

    static func mismatchedMethodEncodingComment(_ encoding: String) -> String {
        " /* mismatched method encoding: \(escapedEncoding(encoding)) */"
    }

    private static func escapedEncoding(_ encoding: String) -> String {
        let encoding = encoding.isEmpty ? "<empty>" : encoding
        return encoding
            .components(separatedBy: .newlines)
            .joined(separator: " ")
            .replacingOccurrences(of: "*/", with: "* /")
    }
}
