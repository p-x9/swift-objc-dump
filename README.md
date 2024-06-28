# swift-objc-dump

A Swift Library for dumping objective-c class/protocol/method/property/ivar informations.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/swift-objc-dump)](https://github.com/p-x9/swift-objc-dump/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-objc-dump)](https://github.com/p-x9/swift-objc-dump/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-objc-dump)](https://github.com/p-x9/swift-objc-dump/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-objc-dump)](https://github.com/p-x9/swift-objc-dump/)

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

/*
@interface NSObject <CARenderValue, CAAnimatableValue, NSObject> {
    Class isa;
}

@property(class, readonly) BOOL accessInstanceVariablesDirectly;

@property(readonly, copy) NSClassDescription *classDescription;
@property(readonly, copy) NSArray *attributeKeys;

/* ...... */

+ (BOOL)xr_object:(id)arg0 isEqual:(id)arg1;
+ (void)dealloc;
+ (id)description;
+ (void)doesNotRecognizeSelector:(SEL)arg0;
+ (id)init;
+ (id)instanceMethodSignatureForSelector:(SEL)arg0;
+ (void)load;
+ (id)methodSignatureForSelector:(SEL)arg0;
+ (id)__allocWithZone_OA:(struct _NSZone {  } *)arg0;

/* ...... */

- (id)performSelector:(SEL)arg0 withObject:(id)arg1 withObject:(id)arg2;
- (BOOL)respondsToSelector:(SEL)arg0;
- (id)retain;
- (unsigned long long)retainCount;
- (BOOL)retainWeakReference;
- (id)self;
- (Class)superclass;
- (struct _NSZone {  } *)zone;

@end
*/
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
