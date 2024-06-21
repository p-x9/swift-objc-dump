//
//  ObjCMethodTypeDecodeTests.swift
//
//
//  Created by p-x9 on 2024/06/22
//  
//

import XCTest
@testable import ObjCTypeDecodeKit

final class ObjCMethodTypeDecodeTests: XCTestCase {
    func test() {
        // Instance Methods
        checkEncode("v32@0:8@16^{CGContext=}24")
        checkEncode("v40@0:8@16^{CGContext=}24@?32")
        checkEncode("v52@0:8B16{CGRect={CGPoint=dd}{CGSize=dd}}20")
        checkEncode("@32@0:8#16:24")
        checkEncode("@40@0:8{CGPoint=dd}16q32")
        checkEncode("@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("^{CGSRegionObject=}56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48B52")
        checkEncode("@24@0:8q16")
        checkEncode("f24@0:8q16")
        checkEncode("v40@0:8@16@24@32")
        checkEncode("@56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}64@0:8{CGPoint=dd}16{CGRect={CGPoint=dd}{CGSize=dd}}32")
        checkEncode("B24@0:8@16")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}36@0:8@16@24B32")
        checkEncode("v16@0:8")
        checkEncode("v40@0:8Q16@24@32")
        checkEncode("@24@0:8^{CGPoint=dd}16")
        checkEncode("B76@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24@56B64@68")
        checkEncode("@16@0:8")
        checkEncode("v36@0:8@16B24@?28")
        checkEncode("B16@0:8")
        checkEncode("v60@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48B56")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}16@0:8")
        checkEncode("@20@0:8B16")
        checkEncode("{CGSize=dd}16@0:8")
        checkEncode("v64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16{CGSize=dd}48")
        checkEncode("v24@0:8d16")
        checkEncode("v56@0:8@16{NSEdgeInsets=dddd}24")
        checkEncode("^{_CAView=}16@0:8")
        checkEncode("B28@0:8@16B24")
        checkEncode("i16@0:8")
        checkEncode("B24@0:8B16B20")
        checkEncode("@24@0:8@?16")
        checkEncode("v40@0:8^{CGSize=dd}16^{CGSize=dd}24^{CGSize=dd}32")
        checkEncode("B32@0:8r^{CGRect={CGPoint=dd}{CGSize=dd}}16@24")
        checkEncode("@?16@0:8")
        checkEncode("v44@0:8^{CGSize=dd}16^{CGSize=dd}24^{CGSize=dd}32f40")
        checkEncode("q64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48@56")
        checkEncode("@48@0:8@16q24@32d40")
        checkEncode("v56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48")
        checkEncode("@32@0:8q16@24")
        checkEncode("d32@0:8^{CGSize=dd}16@24")
        checkEncode("v56@0:8@16{_NSRange=QQ}24@40@?48")
        checkEncode("v20@0:8I16")
        checkEncode("v32@0:8^?16^v24")
        checkEncode("v64@0:8{CGAffineTransform=dddddd}16")
        checkEncode("@24@0:8^{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("B40@0:8@16d24^@32")
        checkEncode("v28@0:8@16B24")
        checkEncode("B68@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24B56@60")
        checkEncode("B40@0:8@16q24@32")
        checkEncode("d16@0:8")
        checkEncode("B56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24")
        checkEncode("v64@0:8B16{CGRect={CGPoint=dd}{CGSize=dd}}20@52B60")
        checkEncode("B52@0:8i16@20d28@36@44")
        checkEncode("B48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("{NSEdgeInsets=dddd}56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48")
        checkEncode("B64@0:8{CGPoint=dd}16{CGRect={CGPoint=dd}{CGSize=dd}}32")
        checkEncode("B24@0:8^v16")
        checkEncode("@24@0:8^{CGSize=dd}16")
        checkEncode("{CGPoint=dd}24@0:8@16")
        checkEncode("v40@0:8@16{CGPoint=dd}24")
        checkEncode("v32@0:8{CGSize=dd}16")
        checkEncode("@28@0:8q16B24")
        checkEncode("Q24@0:8@16")
        checkEncode("v48@0:8Q16d24@32@?40")
        checkEncode("B32@0:8^q16^q24")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}52@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8q16")
        checkEncode("v96@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48@56@64@72q80@88")
        checkEncode("{NSEdgeInsets=dddd}48@0:8{NSEdgeInsets=dddd}16")
        checkEncode("q64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48^v56")
        checkEncode("v84@0:8@16{CGPoint=dd}24{CGSize=dd}40@56@64@72B80")
        checkEncode("{CGAffineTransform=dddddd}24@0:8@16")
        checkEncode("v24@0:8^@16")
        checkEncode("v52@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48")
        checkEncode("v40@0:8@16q24@32")
        checkEncode("B56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48")
        checkEncode("B68@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48B56@?60")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}40@0:8@16q24@32")
        checkEncode("v32@0:8@16@24")
        checkEncode("B32@0:8@16@24")
        checkEncode("@56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24")
        checkEncode("v32@0:8[4{CGRect={CGPoint=dd}{CGSize=dd}}]16^q24")
        checkEncode("v20@0:8B16")
        checkEncode("B28@0:8^{CGPoint=dd}16B24")
        checkEncode("{NSEdgeInsets=dddd}16@0:8")
        checkEncode("{CGPoint=dd}48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("v64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48@52B60")
        checkEncode("v40@0:8@16@24^@32")
        checkEncode("{CGPoint=dd}32@0:8{CGPoint=dd}16")
        checkEncode("v40@0:8^{CGRect={CGPoint=dd}{CGSize=dd}}16^{CGRect={CGPoint=dd}{CGSize=dd}}24Q32")
        checkEncode("v32@0:8r^{CGPoint=dd}16@24")
        checkEncode("v32@0:8@16d24")
        checkEncode("@40@0:8@16{_NSRange=QQ}24")
        checkEncode("@24@0:8Q16")
        checkEncode("v32@0:8r^{CGSize=dd}16@24")
        checkEncode("@24@0:8:16")
        checkEncode("#16@0:8")
        checkEncode("v48@0:8^{CGRect={CGPoint=dd}{CGSize=dd}}16^{CGRect={CGPoint=dd}{CGSize=dd}}24{CGSize=dd}32")
        checkEncode("v60@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24B56")
        checkEncode("v32@0:8@16^@24")
        checkEncode("Vv16@0:8")
        checkEncode("d32@0:8{CGPoint=dd}16")
        checkEncode("@32@0:8@16:24")
        checkEncode("q16@0:8")
        checkEncode("v60@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48@52")
        checkEncode("v28@0:8B16@?20")
        checkEncode("v48@0:8@16q24@32@40")
        checkEncode("v32@0:8{CGPoint=dd}16")
        checkEncode("{CGSize=dd}40@0:8{CGSize=dd}16@32")
        checkEncode("v24@0:8^{?=ddd{?=b1b31}}16")
        checkEncode("v40@0:8@16@24B32B36")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16Q48")
        checkEncode("B44@0:8i16@20d28@36")
        checkEncode("d24@0:8@16")
        checkEncode("@44@0:8Q16@24@32B40")
        checkEncode("{CGAffineTransform=dddddd}16@0:8")
        checkEncode("B24@0:8^{_NSRange=QQ}16")
        checkEncode("@32@0:8{CGPoint=dd}16")
        checkEncode("@32@0:8@16@24")
        checkEncode("v32@0:8r^^{CGRect}16^q24")
        checkEncode("v32@0:8^@16^@24")
        checkEncode("{CGSize=dd}40@0:8{CGSize=dd}16f32f36")
        checkEncode("v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("@36@0:8{CGPoint=dd}16B32")
        checkEncode("@88@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16{CGRect={CGPoint=dd}{CGSize=dd}}48@80")
        checkEncode("Q16@0:8")
        checkEncode("i24@0:8@16")
        checkEncode("{CGSize=dd}24@0:8@16")
        checkEncode("@32@0:8^{CGPoint=dd}16@24")
        checkEncode("v24@0:8^{_CAView=}16")
        checkEncode("v64@0:8^{CGRect={CGPoint=dd}{CGSize=dd}}16@24^^v32^B40^q48q56")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16")
        checkEncode("I16@0:8")
        checkEncode("v24@0:8@16")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16{CGSize=dd}48")
        checkEncode("v24@0:8B16B20")
        checkEncode("v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24")
        checkEncode("B32@0:8{CGPoint=dd}16")
        checkEncode("q68@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48^v56B64")
        checkEncode("v48@0:8@16@24Q32@?40")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}24@0:8@16")
        checkEncode("v72@0:8q16@24{CGRect={CGPoint=dd}{CGSize=dd}}32@64")
        checkEncode("f16@0:8")
        checkEncode("q24@0:8@16")
        checkEncode("{CGPoint=dd}16@0:8")
        checkEncode("v24@0:8Q16")
        checkEncode("^{CGSRegionObject=}52@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16B48")
        checkEncode("v32@0:8@16Q24")
        checkEncode("@24@0:8#16")
        checkEncode("@40@0:8@16@24@32")
        checkEncode("q76@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48^v56B64q68")
        checkEncode("@52@0:8@16B24@28{CGPoint=dd}36")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24")
        checkEncode("v48@0:8^d16d24d32d40")
        checkEncode("v28@0:8f16q20")
        checkEncode("v32@0:8^q16q24")
        checkEncode("v64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16{CGPoint=dd}48")
        checkEncode("{CGSize=dd}40@0:8{CGSize=dd}16Q32")
        checkEncode("B32@0:8@16^@24")
        checkEncode("{CGSize=dd}32@0:8{CGSize=dd}16")
        checkEncode("{CGRect={CGPoint=dd}{CGSize=dd}}56@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48")
        checkEncode("v24@0:8q16")
        checkEncode("{CGPoint=dd}40@0:8{CGPoint=dd}16@32")
        checkEncode("@24@0:8@16")
        checkEncode("q20@0:8B16")
        checkEncode("@28@0:8@16B24")
        checkEncode("v24@0:8@?16")
        checkEncode("{?=dd}32@0:8{CGSize=dd}16")
        checkEncode("B48@0:8^d16@24@32^@40")

        // Class Methods
        checkEncode("v24@0:8@16")
        checkEncode("q16@0:8")
        checkEncode("v24@0:8@?16")
        checkEncode("v16@0:8")
        checkEncode("@24@0:8@16")
        checkEncode("@16@0:8")
        checkEncode("i16@0:8")
        checkEncode("@32@0:8Q16@24")
        checkEncode("Q16@0:8")
        checkEncode("B16@0:8")
        checkEncode("v20@0:8B16")
        checkEncode("#16@0:8")
    }
}

extension ObjCMethodTypeDecodeTests {
    func checkEncode(_ encoded: String) {
        XCTAssertEqual(decoded(encoded)?.encoded(), encoded)
    }
}

extension ObjCMethodTypeDecodeTests {
    func decoded(_ type: String) -> ObjCMethodType? {
        ObjCMethodTypeDecoder.decoded(type)
    }
}
