//
//  types.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import Foundation

// ref: https://github.com/apple-oss-distributions/objc4/blob/01edf1705fbc3ff78a423cd21e03dfc21eb4d780/runtime/runtime.h#L1856

let simpleTypes: [Character: String] = [
    "@": "id",
    "#": "Class",
    ":": "SEL",
    "c": "char",
    "C": "unsigned char",
    "s": "short",
    "S": "unsigned short",
    "i": "int",
    "I": "unsigned int",
    "l": "long",
    "L": "unsigned long",
    "q": "long long",
    "Q": "unsigned long long",
    "t": "__int128_t",
    "T": "__uint128_t",
    "f": "float",
    "d": "double",
    "D": "long double",
    "B": "BOOL",
    "v": "void",
    "?": "unknown",
    "*": "char *",
    "%": "atom" // FIXME: ?????
]

let modifiers: [Character: String] = [
    "A": "_Atomic", // #include <stdatomic.h>
    "j": "_Complex", // #include <complex.h>
    "r": "const",
    "n": "in",
    "N": "inout",
    "o": "out",
    "O": "bycopy",
    "R": "byref",
    "V": "oneway",
    "+": "register", // FIXME: ????
]
