



public struct OrderedDictionary<Key: Hashable, Value> {
    public typealias Element = Value
    private var base: [Key: Value]
    public private(set) var keys: [Key]
    private var keyMaker: (Key?) -> Key
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
    }
    public subscript(key: Key) -> Value? {
        base[key]
    }
}
extension OrderedDictionary: Collection {
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex, "Can't advance beyond endIndex")
        return i + 1
    }

    public subscript(position: Int) -> Element {
        
        let key = keys[position]
        let value = base[key]!
        return value
        
    }

    public var startIndex: Int {
        keys.startIndex
    }

    public var endIndex: Int {
        keys.endIndex
    }
}
