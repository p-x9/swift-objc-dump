//
//  types.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import Foundation

// ref: https://github.com/apple-oss-distributions/objc4/blob/01edf1705fbc3ff78a423cd21e03dfc21eb4d780/runtime/runtime.h#L1856

let simpleTypes: [Character: ObjCType] = [
    "@": .object(name: nil),
    "#": .class,
    ":": .selector,
    "c": .char,
    "C": .uchar,
    "s": .short,
    "S": .ushort,
    "i": .int,
    "I": .uint,
    "l": .long,
    "L": .ulong,
    "q": .longLong,
    "Q": .ulongLong,
    "t": .int128,
    "T": .uint128,
    "f": .float,
    "d": .double,
    "D": .longDouble,
    "B": .bool,
    "v": .void,
    "?": .unknown,
    "*": .charPtr,
    "%": .atom // FIXME: ?????
]

let modifiers: [Character: ObjCModifier] = [
    "A": .atomic, // #include <stdatomic.h>
    "j": .complex, // #include <complex.h>
    "r": .const,
    "n": .in,
    "N": .`inout`,
    "o": .out,
    "O": .bycopy,
    "R": .byref,
    "V": .oneway,
    "+": .register, // FIXME: ????
]
