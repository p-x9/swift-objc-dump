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

    func testNamedId() {
        XCTAssertEqual(
            decoded(#"@"NSLayoutManager""#),
            "NSLayoutManager *"
        )
        XCTAssertEqual(
            decoded(#"@?"#),
            "id /* block */"
        )
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
        XCTAssertEqual(
            decoded("(?=iQ)"),
            """
            union {
                int x0;
                unsigned long long x1;
            }
            """
        )
        XCTAssertEqual(
            decoded("(?=iQ(?=*B))"),
            """
            union {
                int x0;
                unsigned long long x1;
                union {
                    char * x0;
                    BOOL x1;
                } x2;
            }
            """
        )
    }

    func testStruct() {
        XCTAssertEqual(
            decoded("{CGRect={CGPoint=dd}{CGSize=dd}}"),
            """
            struct CGRect {
                struct CGPoint {
                    double x0;
                    double x1;
                } x0;
                struct CGSize {
                    double x0;
                    double x1;
                } x1;
            }
            """
        )
        XCTAssertEqual(
            decoded(#"{CGSize="width"d"height"d}"#),
            """
            struct CGSize {
                double width;
                double height;
            }
            """
        )
        XCTAssertEqual(
            decoded(#"{CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}}"#),
            """
            struct CGRect {
                struct CGPoint {
                    double x;
                    double y;
                } origin;
                struct CGSize {
                    double width;
                    double height;
                } size;
            }
            """
        )
        XCTAssertEqual(
            decoded(#"{_tvFlags="horizontallyResizable"b1"verticallyResizable"b1"viewOwnsTextStorage"b1"displayWithoutLayout"b1"settingMarkedRange"b1"containerOriginInvalid"b1"registeredForDragging"b1"superviewIsClipView"b1"forceRulerUpdate"b1"typingText"b1"wasPostingFrameNotifications"b1"wasRotatedOrScaledFromBase"b1"settingNeedsDisplay"b1"mouseInside"b1"verticalLayout"b2"diagonallyRotatedOrScaled"b1"hasScaledBacking"b1"shouldCloseQL"b1"dragUpdateRequstOwner"b1"genericDragRemoveSource"b1"isAttributedPlaceholder"b1"isDDAction"b1"showingFindIndicator"b1"isDrawingLayer"b1"touchBarInstantiated"b1"calculatingContainerOrigin"b1"doesOverrideDrawInsertionPointInRect"b1"darkEffectiveAppearance"b1"isPresentingReveal"b1"isDrawingFindIndicatorContent"b1"isAutoscrollingForTextLayoutManager"b1"_downgradeState"b2"isWatchingUnspecifiedClipView"b1}"#),
            """
            struct _tvFlags {
                int horizontallyResizable : 1;
                int verticallyResizable : 1;
                int viewOwnsTextStorage : 1;
                int displayWithoutLayout : 1;
                int settingMarkedRange : 1;
                int containerOriginInvalid : 1;
                int registeredForDragging : 1;
                int superviewIsClipView : 1;
                int forceRulerUpdate : 1;
                int typingText : 1;
                int wasPostingFrameNotifications : 1;
                int wasRotatedOrScaledFromBase : 1;
                int settingNeedsDisplay : 1;
                int mouseInside : 1;
                int verticalLayout : 2;
                int diagonallyRotatedOrScaled : 1;
                int hasScaledBacking : 1;
                int shouldCloseQL : 1;
                int dragUpdateRequstOwner : 1;
                int genericDragRemoveSource : 1;
                int isAttributedPlaceholder : 1;
                int isDDAction : 1;
                int showingFindIndicator : 1;
                int isDrawingLayer : 1;
                int touchBarInstantiated : 1;
                int calculatingContainerOrigin : 1;
                int doesOverrideDrawInsertionPointInRect : 1;
                int darkEffectiveAppearance : 1;
                int isPresentingReveal : 1;
                int isDrawingFindIndicatorContent : 1;
                int isAutoscrollingForTextLayoutManager : 1;
                int _downgradeState : 2;
                int isWatchingUnspecifiedClipView : 1;
            }
            """
        )
    }

    func testAtomic() {
        XCTAssertEqual(decoded("Ai"), "_Atomic int")
        XCTAssertEqual(decoded("A*"), "_Atomic char *")
        XCTAssertEqual(
            decoded("^AQ"),
            "_Atomic unsigned long long *"
        )
        XCTAssertEqual(decoded("^A{CGPoint}"), "_Atomic CGPoint *")
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
            """
            union {
                int x0;
                unsigned int x1;
                struct {
                    int x0;
                    struct CGRect {
                        struct CGPoint {
                            double x0;
                            double x1;
                        } x0;
                        struct CGSize {
                            double x0;
                            double x1;
                        } x1;
                    } x1;
                } x2;
            }
            """
        )
    }
}

extension ObjCTypeDecodeKitTests {
    @_disfavoredOverload
    func decoded(_ type: String) -> String? {
        ObjCTypeDecoder.decode(type)?.decoded()
    }

    func decoded(_ type: String) -> ObjCType? {
        ObjCTypeDecoder.decode(type)
    }
}
