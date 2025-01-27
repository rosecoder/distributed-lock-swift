import Logging

/// A distributed lock that does no locking.
/// This is useful for local development and testing.
public struct NoOpDistributedLock: DistributedLock {

  public init() {}

  public func lock(key: Key, logger: Logger) {
    // No-op
  }

  public func unlock(key: Key, startedAt: ContinuousClock.Instant, logger: Logger) {
    // No-op
  }
}
