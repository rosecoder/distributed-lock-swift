import DistributedLock
import Logging
import Synchronization

final class AssertedLock<Lock: DistributedLock>: DistributedLock {

    private let _lock: Lock

    private let _isLocked = Mutex<Bool>(false)
    var isLocked: Bool { _isLocked.withLock { $0 } }

    private let _timeouts = Mutex<[Duration]>([])
    var timeouts: [Duration] { _timeouts.withLock { $0 } }

    init(lock: Lock) {
        self._lock = lock
    }

    func lock(key: Key, timeout: Duration, logger: Logger) async throws {
        _timeouts.withLock { $0.append(timeout) }
        try await _lock.lock(key: key, timeout: timeout, logger: logger)
        _isLocked.withLock { $0 = true }
    }

    func unlock(
        key: Key,
        startedAt: ContinuousClock.Instant,
        timeout: Duration,
        logger: Logger
    ) async throws {
        _isLocked.withLock { $0 = false }
        try await _lock.unlock(key: key, startedAt: startedAt, timeout: timeout, logger: logger)
    }
}
