



public struct OrderedDictionary<Key: Hashable, Value> {
    public typealias Element = Value
    private var base: [Key: Value]
    public private(set) var keys: [Key]
    private var keyMaker: (Key?) -> Key
    private var previousKey: Key?
    public init(values: [Value], keyMaker: @escaping (Key?) -> Key) {
        var base = [Key: Value]()
        var keys = [Key]()
        var previousKey: Key?
        for value in values {
            let key = keyMaker(previousKey)
            base[key] = value
            keys.append(key)
            previousKey = key
        }
        self.base = base
        self.keys = keys
        self.keyMaker = keyMaker
        self.previousKey = previousKey
    }
    public subscript(key: Key) -> Value? {
        get {
            base[key]
        }
        set {
            switch (base[key], newValue) {
            case (.none, .some):
                keys.append(key)
            case (.some, .none):
                keys.removeAll { $0 == key }
            default:
                break
            }
            base[key] = newValue
        }
    }
}
extension OrderedDictionary: MutableCollection {
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex, "Can't advance beyond endIndex")
        return i + 1
    }

    public subscript(position: Int) -> Element {
        get {
            let key = keys[position]
            let value = base[key]!
            return value
        }
        set {
            let key = keyMaker(previousKey)
            keys[position] = key
            base[key] = newValue
            previousKey = key
        }
    }

    public var startIndex: Int {
        keys.startIndex
    }

    public var endIndex: Int {
        keys.endIndex
    }
}
