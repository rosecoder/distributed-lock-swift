import DistributedLock
import Testing

@Suite struct NoOpDistributedLockTests {

    @Test func shouldLockAndUnlock() async throws {
        let lock = AssertedLock(lock: NoOpDistributedLock())

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask {
                try await lock.withLock("a") {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
            group.addTask {
                try await Task.sleep(for: .milliseconds(50))
                try await lock.withLock("a") {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
        }
    }
}
