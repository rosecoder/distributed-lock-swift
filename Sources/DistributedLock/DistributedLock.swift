import Logging

public protocol DistributedLock: Sendable {

  /// Acquires the lock for `key`, waiting until it is available.
  ///
  /// - Parameter timeout: How long the lock is held before the implementation releases it on its
  ///   own. It bounds the critical section rather than only guarding against crashed holders: an
  ///   operation running longer than the timeout loses its lock while still running, and another
  ///   holder can then acquire it concurrently. Pass a timeout above the longest critical section
  ///   the caller expects.
  func lock(key: Key, timeout: Duration, logger: Logger) async throws

  /// Releases the lock for `key`.
  ///
  /// - Parameters:
  ///   - startedAt: When the lock was acquired, so implementations can tell whether it has since
  ///     expired and may now belong to another holder.
  ///   - timeout: The timeout the lock was acquired with.
  func unlock(
    key: Key,
    startedAt: ContinuousClock.Instant,
    timeout: Duration,
    logger: Logger
  ) async throws
}

extension DistributedLock {

  /// Used by the overloads that take no explicit timeout.
  public static var defaultTimeout: Duration { .seconds(30) }

  public func lock(key: Key, logger: Logger) async throws {
    try await lock(key: key, timeout: Self.defaultTimeout, logger: logger)
  }

  public func unlock(
    key: Key,
    startedAt: ContinuousClock.Instant,
    logger: Logger
  ) async throws {
    try await unlock(key: key, startedAt: startedAt, timeout: Self.defaultTimeout, logger: logger)
  }
}
