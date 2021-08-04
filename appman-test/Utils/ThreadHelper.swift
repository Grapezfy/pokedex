public func main(_ execute: @escaping () -> Void) {
    DispatchQueue.main.async(execute: execute)
}

public func main(with secondDelay: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + secondDelay, execute: execute)
}
