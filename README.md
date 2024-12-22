# Distributed Lock for Swift

This package provides a Swift implementation for distributed locking. It allows coordination between multiple processes or services to ensure exclusive access to shared resources.

This package exposes a single protocol `DistributedLock` that can be implemented by any distributed lock provider. It also provides two implementations:

- `LocalDistributedLock`: A distributed lock that is implemented using a local lock. This is useful for local development and testing.
- `NoOpDistributedLock`: A distributed lock that does no locking. This is useful for local development and testing.

## Example usage

```swift
import DistributedLock

let lock = MyLockImplementation()

try await lock.withLock("my-resource") {
    // operations that should be protected by the lock
}
```

It also provides logging and tracing support for the time the lock is waiting to be acquired.
