//
//  Bindable.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/06/2022.
//

class Bindable<T> {
    
    typealias Listener = ((T) -> Void)
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        self.value = v
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func unbind() {
        self.listener = nil
    }
    
    func unbindWithCleanup(_ cleanup: () -> Void) {
        self.listener = nil
        cleanup()
    }
}
