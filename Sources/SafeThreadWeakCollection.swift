import Foundation

struct  WeakWrapper {
    private(set) weak var value: AnyObject?

    init(_ value: AnyObject) {
        self.value = value
    }
}


public class SafeThreadWeakCollection<T> {

    public typealias Element = T

    private var observersLock = os_unfair_lock()
    private var weakReferences: [WeakWrapper] = [WeakWrapper]()

    public init() {}

    public var references: [T] {
        os_unfair_lock_lock(&observersLock)
        defer {
            os_unfair_lock_unlock(&observersLock)
        }
        return weakReferences.compactMap({ $0.value as? T })
    }

    public func contains(where predicate: (_ o: Element) -> Bool) -> Bool {
        os_unfair_lock_lock(&observersLock)
        defer {
            os_unfair_lock_unlock(&observersLock)
        }
        return weakReferences.contains(where: {
            guard let v = $0.value as? T else {
                return false
            }
            return predicate(v)
        })
    }

    public func add(_ object: T) -> Int? {
        os_unfair_lock_lock(&observersLock)
        defer {
            os_unfair_lock_unlock(&observersLock)
        }
        removeNil()
        guard
            weakReferences.filter({ (reference: WeakWrapper) -> Bool in
                let refValue = reference.value as AnyObject
                let refObject = object as AnyObject

                return refValue === refObject
            }).count == 0
        else {
            return nil
        }

        self.weakReferences.append(WeakWrapper(object as AnyObject))
        return self.weakReferences.count
    }

    @discardableResult
    public func remove(_ delegate: T) -> Int {
        os_unfair_lock_lock(&observersLock)
        defer {
            os_unfair_lock_unlock(&observersLock)
        }
        removeNil()
        guard
            let index = weakReferences.firstIndex(where: { ($0.value as AnyObject) === (delegate as AnyObject)})
        else {
            return self.weakReferences.count
        }
        self.weakReferences.remove(at: index)
        return self.weakReferences.count
    }

    public func execute(_ closure: ((_ object: T) throws -> Void)) {
        os_unfair_lock_lock(&observersLock)
        removeNil()
        let objs = weakReferences.reversed().compactMap({ $0.value as? T })
        os_unfair_lock_unlock(&observersLock)

        objs.forEach {
            try? closure($0)
        }
    }

    public func execute(_ closure: @escaping ((_ object: T) async throws -> Void)) {
        os_unfair_lock_lock(&observersLock)
        removeNil()
        let objs = self.weakReferences.reversed().compactMap({ $0.value as? T })
        os_unfair_lock_unlock(&observersLock)
        Task {
            for obj in objs {
                try? await closure(obj)
            }
        }
    }

    fileprivate func removeNil() {
        while let index = weakReferences.firstIndex(where: { $0.value == nil }) {
            weakReferences.remove(at: index)
        }
    }
}
