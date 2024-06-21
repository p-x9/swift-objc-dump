//
//  ObjCTypeEncodeTests.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import XCTest
@testable import ObjCTypeDecodeKit

final class ObjCTypeEncodeTests: XCTestCase {
    func testSimpleTypes() {
        checkEncode("@")
        checkEncode("#")
        checkEncode(":")

        checkEncode("c")
        checkEncode("C")

        checkEncode("s")
        checkEncode("S")

        checkEncode("i")
        checkEncode("I")

        checkEncode("l")
        checkEncode("L")

        checkEncode("q")
        checkEncode("Q")

        checkEncode("t")
        checkEncode("T")

        checkEncode("f")

        checkEncode("d")
        checkEncode("D")

        checkEncode("B")
        checkEncode("v")
        checkEncode("?")
        checkEncode("*")

        checkEncode("%") // FIXME: ?????
    }

    func testNamedId() {
        checkEncode(#"@"NSLayoutManager""#)
        checkEncode(#"@?"#)
    }

    func testPointers() {
        checkEncode("^i")
        checkEncode("^v")
    }

    func testArray() {
        checkEncode("[i]")
        checkEncode("[128i]")
        checkEncode("[128^i]")
    }

    func testUnion() {
        checkEncode("(?=iQ)")
        checkEncode("(?=iQ(?=*B))")
    }

    func testStruct() {
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}")
        checkEncode(#"{CGSize="width"d"height"d}"#)
        checkEncode(#"{CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}}"#)
        checkEncode(#"{_tvFlags="horizontallyResizable"b1"verticallyResizable"b1"viewOwnsTextStorage"b1"displayWithoutLayout"b1"settingMarkedRange"b1"containerOriginInvalid"b1"registeredForDragging"b1"superviewIsClipView"b1"forceRulerUpdate"b1"typingText"b1"wasPostingFrameNotifications"b1"wasRotatedOrScaledFromBase"b1"settingNeedsDisplay"b1"mouseInside"b1"verticalLayout"b2"diagonallyRotatedOrScaled"b1"hasScaledBacking"b1"shouldCloseQL"b1"dragUpdateRequstOwner"b1"genericDragRemoveSource"b1"isAttributedPlaceholder"b1"isDDAction"b1"showingFindIndicator"b1"isDrawingLayer"b1"touchBarInstantiated"b1"calculatingContainerOrigin"b1"doesOverrideDrawInsertionPointInRect"b1"darkEffectiveAppearance"b1"isPresentingReveal"b1"isDrawingFindIndicatorContent"b1"isAutoscrollingForTextLayoutManager"b1"_downgradeState"b2"isWatchingUnspecifiedClipView"b1}"#)
    }

    func testAtomic() {
        checkEncode("Ai")
        checkEncode("A*")
        checkEncode("^AQ")
        XCTAssertEqual(decoded("^A{CGPoint}"), "_Atomic CGPoint *")
    }

    func testComplex() {
        checkEncode("ji")
        checkEncode("^jQ")
    }

    func test() {
        checkEncode("(?=iI{?=i{CGRect={CGPoint=dd}{CGSize=dd}}})")
    }
}

extension ObjCTypeEncodeTests {
    func checkEncode(_ encoded: String) {
        XCTAssertEqual(decoded(encoded)?.encoded(), encoded)
    }
}

extension ObjCTypeEncodeTests {
    @_disfavoredOverload
    func decoded(_ type: String) -> String? {
        ObjCTypeDecoder.decoded(type)?.decoded()
    }

    func decoded(_ type: String) -> ObjCType? {
        ObjCTypeDecoder.decoded(type)
    }
}
