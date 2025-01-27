public struct Key: Sendable {

  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

extension Key: Hashable {}
extension Key: Equatable {}

extension Key: CustomStringConvertible {

  public var description: String {
    rawValue
  }
}

extension Key: CustomDebugStringConvertible {

  public var debugDescription: String {
    "Key(\(rawValue))"
  }
}

extension Key: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.rawValue = value
  }
}
