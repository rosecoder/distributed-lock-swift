import Logging
import Tracing

extension DistributedLock {

  @discardableResult
  public func withLock<Result: Sendable>(
    _ key: Key,
    isolation: isolated (any Actor)? = #isolation,
    operation: () async throws -> Result
  ) async throws -> Result {
    let logger = Logger(label: "distributed-lock")

    // Lock
    let start = ContinuousClock.Instant.now
    try await withSpan("lock-wait") { span in
      span.attributes["key"] = key.rawValue

      try await lock(key: key, logger: logger)
    }

    // Unlock async after return
    defer {
      Task {
        do {
          try await unlock(key: key, startedAt: start, logger: logger)
        } catch {
          logger.error(
            "Failed to unlock lock (\(key.rawValue)): \(error)"
          )
        }
      }
    }

    // Perform operation
    return try await operation()
  }

  @discardableResult
  public func withLock<Result: Sendable>(
    _ keys: Set<Key>,
    isolation: isolated (any Actor)? = #isolation,
    operation: () async throws -> Result
  ) async throws -> Result {
    let logger = Logger(label: "distributed-lock")

    // Lock
    let start = ContinuousClock.Instant.now
    try await withThrowingDiscardingTaskGroup { group in
      for key in keys {
        group.addTask {
          try await withSpan("lock-wait") { span in
            span.attributes["key"] = key.rawValue

            try await lock(key: key, logger: logger)
          }
        }
      }
    }

    // Unlock async after return
    defer {
      Task {
        try await withThrowingDiscardingTaskGroup { group in
          for key in keys {
            group.addTask {
              do {
                try await unlock(key: key, startedAt: start, logger: logger)
              } catch {
                logger.error(
                  "Failed to unlock lock (\(key.rawValue)): \(error)"
                )
              }
            }
          }
        }
      }
    }

    // Perform operation
    return try await operation()
  }
}
