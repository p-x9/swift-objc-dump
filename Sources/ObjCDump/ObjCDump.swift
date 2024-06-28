import Foundation

// MARK: - Functions for Class

/// Obtain informations about the class.
/// - Parameter cls: Target class.
/// - Returns: Information about the class, e.g. property lists, method lists, etc.
@inlinable
public func classInfo(for cls: AnyClass) -> ObjCClassInfo? {
    ObjCClassInfo(cls)
}

/// Obtain a list of information on the protocols to which the class conforms.
/// - Parameter cls: Target class
/// - Returns: List of protocol infos
@inlinable
public func protocols(of cls: AnyClass) -> [ObjCProtocolInfo] {
    ObjCClassInfo.protocols(of: cls)
}

/// Obtain a list of Instance variables held by the class.
/// - Parameter cls: Target class
/// - Returns: List of ivar infos
@inlinable
public func ivars(of cls: AnyClass) -> [ObjCIvarInfo] {
    ObjCClassInfo.ivars(of: cls)
}

/// Obtain a list of properties held by the class.
/// - Parameters:
///   - cls: Target class
///   - isInstance: A Boolean value that indicates whether the instance property is targeted.
/// - Returns: List of property infos
@inlinable
public func properties(of cls: AnyClass, isInstance: Bool) -> [ObjCPropertyInfo] {
    ObjCClassInfo.properties(of: cls, isInstance: isInstance)
}

/// Obtain a list of method held by the class.
/// - Parameters:
///   - cls: Target class
///   - isInstance: A Boolean value that indicates whether the instance methods is targeted.
/// - Returns: List of method infos
@inlinable
public func methods(of cls: AnyClass, isInstance: Bool) -> [ObjCMethodInfo] {
    ObjCClassInfo.methods(of: cls, isInstance: isInstance)
}

// MARK: - Functions for Protocol

/// Obtain informations about the protocol.
/// - Parameter `protocol`: Target protocol
/// - Returns: Information about the protocol, e.g. property lists, method lists, etc.
@inlinable
public func protocolInfo(for `protocol`: Protocol) -> ObjCProtocolInfo? {
    ObjCProtocolInfo(`protocol`)
}

/// Obtain a list of information on the protocols to which the protocol conforms.
/// - Parameter `protocol`: Target class
/// - Returns: List of protocol infos
@inlinable
public func protocols(of `protocol`: Protocol) -> [ObjCProtocolInfo] {
    ObjCProtocolInfo.protocols(of: `protocol`)
}

/// Obtain a list of  (optionally) required properties by the protocol.
/// - Parameters:
///   - `protocol`: Target protocol
///   - isRequired: A Boolean value that indicates whether it is required or optional
///   - isInstance: A Boolean value that indicates whether the instance properties is targeted.
/// - Returns: List of (optionally) required property infos
@inlinable
public func properties(
    of `protocol`: Protocol,
    isRequired: Bool,
    isInstance: Bool
) -> [ObjCPropertyInfo] {
    ObjCProtocolInfo.properties(
        of: `protocol`, isRequired: isRequired, isInstance: isInstance
    )
}

/// Obtain a list of  (optionally) required method by the protocol.
/// - Parameters:
///   - `protocol`: Target protocol
///   - isRequired: A Boolean value that indicates whether it is required or optional
///   - isInstance: A Boolean value that indicates whether the instance method is targeted.
/// - Returns: List of (optionally) required method infos
@inlinable
public func methods(
    of `protocol`: Protocol,
    isRequired: Bool,
    isInstance: Bool
) -> [ObjCMethodInfo] {
    ObjCProtocolInfo.methods(
        of: `protocol`, isRequired: isRequired, isInstance: isInstance
    )
}
