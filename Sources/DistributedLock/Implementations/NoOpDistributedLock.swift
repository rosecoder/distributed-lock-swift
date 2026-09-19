import Logging

/// A distributed lock that does no locking.
/// This is useful for local development and testing.
public struct NoOpDistributedLock: DistributedLock {

  public init() {}

  public func lock(key: Key, timeout: Duration, logger: Logger) {
    // No-op
  }

  public func unlock(
    key: Key,
    startedAt: ContinuousClock.Instant,
    timeout: Duration,
    logger: Logger
  ) {
    // No-op
  }
}
