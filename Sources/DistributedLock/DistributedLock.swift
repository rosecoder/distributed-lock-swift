import Logging

public protocol DistributedLock: Sendable {

  func lock(key: Key, logger: Logger) async throws
  func unlock(key: Key, startedAt: ContinuousClock.Instant, logger: Logger) async throws
}
