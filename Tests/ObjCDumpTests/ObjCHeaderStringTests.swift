import XCTest
@testable import ObjCDump

final class ObjCHeaderStringTests: XCTestCase {
    func testSignedCharIvarUsesBOOL() {
        let info = ObjCIvarInfo(
            name: "_signedChar",
            typeEncoding: "c",
            offset: 0
        )

        XCTAssertEqual(info.headerString, "BOOL _signedChar;")
    }

    func testUnsignedCharIvarRemainsUnsignedChar() {
        let info = ObjCIvarInfo(
            name: "_unsignedChar",
            typeEncoding: "C",
            offset: 1
        )

        XCTAssertEqual(info.headerString, "unsigned char _unsignedChar;")
    }

    func testArrayIvarPlacesNameBeforeArraySuffix() {
        let info = ObjCIvarInfo(
            name: "_reserved",
            typeEncoding: "[128C]",
            offset: 0
        )

        XCTAssertEqual(info.headerString, "unsigned char _reserved[128];")
    }

    func testSignedCharPropertyUsesBOOL() {
        let info = ObjCPropertyInfo(
            name: "enabled",
            attributes: "Tc,N",
            isClassProperty: false
        )

        XCTAssertEqual(info.headerString, "@property(nonatomic) BOOL enabled;")
    }

    func testUnsignedCharPropertyRemainsUnsignedChar() {
        let info = ObjCPropertyInfo(
            name: "byte",
            attributes: "TC,N",
            isClassProperty: false
        )

        XCTAssertEqual(
            info.headerString,
            "@property(nonatomic) unsigned char byte;"
        )
    }

    func testNamedStructPropertyUsesTypeName() {
        let info = ObjCPropertyInfo(
            name: "frame",
            attributes: "T{CGRect={CGPoint=dd}{CGSize=dd}},N",
            isClassProperty: false
        )

        XCTAssertEqual(info.headerString, "@property(nonatomic) CGRect frame;")
    }

    func testNamedUnionPropertyUsesTypeName() {
        let info = ObjCPropertyInfo(
            name: "value",
            attributes: "T(Value=iQ),N",
            isClassProperty: false
        )

        XCTAssertEqual(info.headerString, "@property(nonatomic) Value value;")
    }

    func testAnonymousStructPropertyKeepsDefinition() {
        let info = ObjCPropertyInfo(
            name: "pair",
            attributes: "T{?=ii},N",
            isClassProperty: false
        )

        XCTAssertEqual(
            info.headerString,
            """
            @property(nonatomic) struct {
                int x0;
                int x1;
            } pair;
            """
        )
    }

    func testBlockPropertyPlacesNameInsideBlockDeclarator() {
        let info = ObjCPropertyInfo(
            name: "handler",
            attributes: "T@?<v@?i>,C",
            isClassProperty: false
        )

        XCTAssertEqual(
            info.headerString,
            "@property(copy) void (^handler)(int);"
        )
    }

    func testUnknownIvarUsesOpaquePointerWithRawEncoding() {
        let info = ObjCIvarInfo(
            name: "_value",
            typeEncoding: "!",
            offset: 0
        )

        XCTAssertEqual(
            info.headerString,
            "void *_value /* unknown: ! */;"
        )
    }

    func testUnknownPropertyUsesOpaquePointerWithRawEncoding() {
        let info = ObjCPropertyInfo(
            name: "value",
            attributes: "T!,N",
            isClassProperty: false
        )

        XCTAssertEqual(
            info.headerString,
            "@property(nonatomic) void *value /* unknown: ! */;"
        )
    }

    func testUnknownMethodKeepsEverySelectorLabel() {
        let info = ObjCMethodInfo(
            name: "doThing:withValue:",
            typeEncoding: "!",
            isClassMethod: false
        )

        XCTAssertEqual(
            info.headerString,
            "- (void * /* unknown */)doThing:"
                + "(void * /* unknown */)arg0 withValue:"
                + "(void * /* unknown */)arg1;"
                + " /* unknown method encoding: ! */"
        )
    }
}
