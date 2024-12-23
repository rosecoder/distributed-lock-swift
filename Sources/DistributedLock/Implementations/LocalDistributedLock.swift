#if canImport(Foundation)
import Foundation
import Logging

/// A distributed lock that is implemented using a local lock.
/// This is useful for local development and testing.
public struct LocalDistributedLock: DistributedLock {

    private let _lock = NSLock()

    public init() {}

    public func lock(key: String, logger: Logger) {
        _lock.lock()
    }

    public func unlock(key: String, startedAt: ContinuousClock.Instant, logger: Logger) {
        _lock.unlock()
    }
}
#endif
