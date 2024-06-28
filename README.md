# swift-objc-dump

A Swift Library for dumping objective-c class/protocol/method/property/ivar informations.

## Usage

Information on Objective-C class/protocol/method/property/ivar can be obtained as follows.

```swift
import ObjCDump

// Class
let info = classInfo(of: NSObject.self)
let methods = info.methods
/* or */
let methods = methods(of: NSObject.self, isInstance: true)

// Protocol
let `prtocol` = NSProtocolFromString("NSCoding")!
let info = protocolInfo(of: `protocol`)
let methods = info.optionalMethods
/* or */
let methods = methods(of: `protocol`, isRequired: false, isInstance: true)

// Method
let method = class_getInstanceMethod(NSObject.self, NSSelectorFromString("init"))!
let info = ObjCMethodInfo(method)

// Property
let property = class_getProperty(NSObject.self, "classDescription")!
let info = ObjCPropertyInfo(method)

// Ivar
let ivar: Ivar = /**/
let info = ObjCIvarInfo(ivar)
```

### header string

It is possible to output Objective-C headers as follows.

```swift
import ObjCDump

let info = classInfo(of: NSObject.self)
print(info.headerString)
```

### Objective-C type encoding

The type information obtained at ObjC line time is encoded.
This is the same conversion that can be obtained with the @encode directive in Objective-C.

[Reference](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100)

As there are no published functions for decoding this encoded type information, a new decoder has been implemented.
It can be used as follows

```swift
import ObjCTypeDecodeKit

let type = ObjCTypeDecoder.decode("(?=iI{?=i{CGRect={CGPoint=dd}{CGSize=dd}}})")

print(type.decoded())
/*
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
*/
```

## License

swift-objc-dump is released under the MIT License. See [LICENSE](./LICENSE)
