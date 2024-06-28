import XCTest
@testable import ObjCDump

final class ObjCDumpTests: XCTestCase {
    func testClass() {
        guard let info = classInfo(for: ObjCDumpTests.self) else {
            XCTAssert(true)
            return
        }
        print(info.headerString)
    }

    func testProtocol() {
        guard let `protocol` = NSProtocolFromString("NSCoding"),
              let info = protocolInfo(for: `protocol`) else {
            XCTAssert(true)
            return
        }
        print(info.headerString)
    }
}
