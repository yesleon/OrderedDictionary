

public protocol KeyMaking {
    static func makeKey(isUnique: (Self) -> Bool) -> Self
}

public struct OrderedDictionary<Key: Hashable & KeyMaking, Value> {
    
    public typealias Element = Value
    
    private var base: [Key: Value]
    
    public private(set) var keys: [Key]
    
    public var values: [Value] {
        keys.map { base[$0]! }
    }
    
    public init(values: [Value]) {
        var base = [Key: Value]()
        var keys = [Key]()
        
        for value in values {
            let key = Key.makeKey(isUnique: { base[$0] == nil })
            base[key] = value
            keys.append(key)
        }
        self.base = base
        self.keys = keys
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
            let key = Key.makeKey(isUnique: { base[$0] == nil })
            keys[position] = key
            base[key] = newValue
        }
    }

    public var startIndex: Int {
        keys.startIndex
    }

    public var endIndex: Int {
        keys.endIndex
    }
}

extension OrderedDictionary: Hashable where Value: Hashable { }

extension OrderedDictionary: Equatable where Value: Equatable { }
