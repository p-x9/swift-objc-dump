//
//  ObjCTypeDecodeKitTests.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import XCTest
@testable import ObjCTypeDecodeKit

final class ObjCTypeDecodeKitTests: XCTestCase {
    func testSimpleTypes() {
        XCTAssertEqual(decoded("@"), "id")
        XCTAssertEqual(decoded("#"), "Class")
        XCTAssertEqual(decoded(":"), "SEL")

        XCTAssertEqual(decoded("c"), "char")
        XCTAssertEqual(decoded("C"), "unsigned char")

        XCTAssertEqual(decoded("s"), "short")
        XCTAssertEqual(decoded("S"), "unsigned short")

        XCTAssertEqual(decoded("i"), "int")
        XCTAssertEqual(decoded("I"), "unsigned int")

        XCTAssertEqual(decoded("l"), "long")
        XCTAssertEqual(decoded("L"), "unsigned long")

        XCTAssertEqual(decoded("q"), "long long")
        XCTAssertEqual(decoded("Q"), "unsigned long long")

        XCTAssertEqual(decoded("t"), "__int128_t")
        XCTAssertEqual(decoded("T"), "__uint128_t")

        XCTAssertEqual(decoded("f"), "float")

        XCTAssertEqual(decoded("d"), "double")
        XCTAssertEqual(decoded("D"), "long double")

        XCTAssertEqual(decoded("B"), "BOOL")
        XCTAssertEqual(decoded("v"), "void")
        XCTAssertEqual(decoded("?"), "unknown")
        XCTAssertEqual(decoded("*"), "char *")

        XCTAssertEqual(decoded("%"), "atom") // FIXME: ?????
    }

    func testPointers() {
        XCTAssertEqual(decoded("^i"), "int *")
        XCTAssertEqual(decoded("^v"), "void *")
    }

    func testArray() {
        XCTAssertEqual(decoded("[i]"), "int[]")
        XCTAssertEqual(decoded("[128i]"), "int[128]")
        XCTAssertEqual(decoded("[128^i]"), "int *[128]")
    }

    func testUnion() {
        XCTAssertEqual(decoded("(?=iQ)"), "union  { int x0; unsigned long long x1; }")
        XCTAssertEqual(
            decoded("(?=iQ(?=*B))"),
            "union  { int x0; unsigned long long x1; union  { char * x0; BOOL x1; } x2; }"
        )
    }

    func testStruct() {
        XCTAssertEqual(
            decoded("{CGRect={CGPoint=dd}{CGSize=dd}}"),
            "struct CGRect { struct CGPoint { double x0; double x1; } x0; struct CGSize { double x0; double x1; } x1; }"
        )
    }

    func testAtomic() {
        XCTAssertEqual(decoded("Ai"), "_Atomic int")
        XCTAssertEqual(decoded("A*"), "_Atomic char *")
        XCTAssertEqual(
            decoded("^AQ"),
            "_Atomic unsigned long long *"
        )
//        XCTAssertEqual(decoded("^A{CGPoint}"), "_Atomic CGPoint *")
    }

    func testComplex() {
        XCTAssertEqual(decoded("ji"), "_Complex int")
        XCTAssertEqual(
            decoded("^jQ"),
            "_Complex unsigned long long *"
        )
    }

    func test() {
        XCTAssertEqual(
            decoded("(?=iI{?=i{CGRect={CGPoint=dd}{CGSize=dd}}})"),
            "union  { int x0; unsigned int x1; struct  { int x0; struct CGRect { struct CGPoint { double x0; double x1; } x0; struct CGSize { double x0; double x1; } x1; } x1; } x2; }"
        )
    }
}

extension ObjCTypeDecodeKitTests {
    func decoded(_ type: String) -> String? {
        ObjCTypeDecoder.decoded(type)
    }
}
