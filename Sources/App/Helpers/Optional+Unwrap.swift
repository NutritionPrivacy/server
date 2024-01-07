import Foundation

extension Optional {
  struct Nil: Error {}

  public func unwrap() throws -> Wrapped {
    guard let unwrapped = self else { throw Nil() }
    return unwrapped
  }
}
