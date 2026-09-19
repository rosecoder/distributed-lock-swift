import DistributedLock
import Testing

@Suite struct WithLockTests {

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

    @Test func shouldDefaultToThirtySeconds() async throws {
        let lock = AssertedLock(lock: LocalDistributedLock())

        try await lock.withLock("a") {}

        #expect(lock.timeouts == [.seconds(30)])
        #expect(LocalDistributedLock.defaultTimeout == .seconds(30))
    }

    @Test func shouldUseTheGivenTimeout() async throws {
        let lock = AssertedLock(lock: LocalDistributedLock())

        try await lock.withLock("a", timeout: .seconds(600)) {}

        #expect(lock.timeouts == [.seconds(600)])
    }

    @Test func shouldUseTheGivenTimeoutForEveryKey() async throws {
        let lock = AssertedLock(lock: LocalDistributedLock())

        try await lock.withLock(["a", "b"], timeout: .seconds(600)) {}

        #expect(lock.timeouts == [.seconds(600), .seconds(600)])
    }

    @Test func shouldLockAndUnlockUsingMultipleKeys() async throws {
        let lock = AssertedLock(lock: LocalDistributedLock())

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask {
                #expect(lock.isLocked == false)
                try await lock.withLock(["a", "b"]) {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
            group.addTask {
                try await Task.sleep(for: .milliseconds(50))
                #expect(lock.isLocked == true)
                try await lock.withLock(["a", "b"]) {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
        }
    }
}
