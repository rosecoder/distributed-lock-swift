#if canImport(Foundation)
  import Foundation
  import Logging
  import Synchronization

  /// A distributed lock that is implemented using a local lock.
  /// This is useful for local development and testing.
  public final class LocalDistributedLock: DistributedLock {

    private let nsLocks = Mutex<[Key: NSLock]>([:])

    public init() {}

    public func lock(key: Key, logger: Logger) {
      nsLock(key: key).lock()
    }

    public func unlock(key: Key, startedAt: ContinuousClock.Instant, logger: Logger) {
      nsLock(key: key).unlock()
    }

    private func nsLock(key: Key) -> NSLock {
      self.nsLocks.withLock { nsLocks in
        if let lock = nsLocks[key] {
          return lock
        }

        let lock = NSLock()
        nsLocks[key] = lock
        return lock
      }
    }
  }
#endif
