import DistributedLock
import Testing

@Suite struct KeyTests {

    @Test func shouldInitializeWithRawValue() {
        let key = Key(rawValue: "test-key")
        #expect(key.rawValue == "test-key")
    }

    @Test func shouldBeEquatable() {
        let key1 = Key(rawValue: "test-key")
        let key2 = Key(rawValue: "test-key")
        let key3 = Key(rawValue: "different-key")

        #expect(key1 == key2)
        #expect(key1 != key3)
    }

    @Test func shouldBeHashable() {
        let key1 = Key(rawValue: "test-key")
        let key2 = Key(rawValue: "test-key")

        var set = Set<Key>()
        set.insert(key1)
        set.insert(key2)

        #expect(set.count == 1)
    }

    @Test func shouldProvideDescription() {
        let key = Key(rawValue: "test-key")
        #expect(key.description == "test-key")
    }

    @Test func shouldProvideDebugDescription() {
        let key = Key(rawValue: "test-key")
        #expect(key.debugDescription == "Key(test-key)")
    }

    @Test func shouldBeExpressibleByStringLiteral() {
        let key: Key = "test-key"
        #expect(key.rawValue == "test-key")
    }
}
