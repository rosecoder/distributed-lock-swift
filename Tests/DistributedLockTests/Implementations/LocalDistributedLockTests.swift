import DistributedLock
import Testing

@Suite struct LocalDistributedLockTests {

    @Test func shouldLockAndUnlock() async throws {
        let lock = AssertedLock(lock: LocalDistributedLock())

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask {
                #expect(lock.isLocked == false)
                try await lock.withLock("a") {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
            group.addTask {
                try await Task.sleep(for: .milliseconds(50))
                #expect(lock.isLocked == true)
                try await lock.withLock("a") {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
        }
    }
}
