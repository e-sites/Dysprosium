//
//  Dysprosium.swift
//  ios-library
//
//  Created by Bas van Kuijck on 07-01-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

import Foundation
import UIKit

// MARK: - DysprosiumObject
// _____________________________________________________________________________________________________________________

public struct DysprosiumObject: CustomStringConvertible, Equatable {
    public let className: String
    public let memoryName: String

    init(className: String, memoryName: String) {
        self.className = className //String(describing: type(of: object))
        self.memoryName = memoryName //Dysprosium.shared.getMemoryName(of: object)
    }

    public var description: String {
        return String(format: "<%@:%@>", classNameDescription, memoryName)
    }

    public var classNameDescription: String {
        if let prefix = Dysprosium.shared.ignoredPrefix {
            return className.replacingOccurrences(of: "\(prefix).", with: "")
        }
        return className
    }

    public static func == (lhs: DysprosiumObject, rhs: DysprosiumObject) -> Bool {
        return lhs.memoryName == rhs.memoryName
    }
}

// MARK: - Dysprosium
// _____________________________________________________________________________________________________________________

public class Dysprosium {

    private let _lockQueue: DispatchQueue!

    private var _onExpectedDeallocation: ((DysprosiumObject, String) -> Void)?
    private var _onDealloc: (([DysprosiumObject]) -> Void)?

    public var ignoredPrefix: String?

    /// Private variables
    fileprivate var _deallocatedObjects: [DysprosiumObject] = []
    fileprivate var _deallocTimer: Timer?

    // MARK: - Constructor
    // _________________________________________________________________________________________________________________

    /// Returns the shared Dysprosium object
    ///
    /// - Returns: `Dysprosium` The shared Dysprosium object
    public static let shared = Dysprosium()

    #if DEBUG
    public var isEnabled = true
    #else
    public var isEnabled = false
    #endif

    private init() {
        _lockQueue = DispatchQueue(label: "com.esites.library.dysprosium")
    }

    // MARK: - Methods
    // _________________________________________________________________________________________________________________

    /**
     :see: deallocatedObject() for more information
     */
    public func deallocated(object: DysprosiumCompatible) {
        if !isEnabled {
            return
        }

        _lockQueue.sync {
            let memoryName = self.getMemoryName(of: object)
            let filteredArray = self._deallocatedObjects.filter { model -> Bool in
                return model.memoryName == memoryName
            }

            if !filteredArray.isEmpty {
                return
            }
            let deallocModel = DysprosiumObject(className: String(describing: type(of: object)), memoryName: memoryName)
            self._deallocatedObjects.append(deallocModel)
            self._deallocTimer?.invalidate()
            self._deallocTimer = Timer(timeInterval: 0.2,
                                       target: self,
                                       selector: #selector(self._deallocatedTimerFinished(timer:)),
                                       userInfo: nil,
                                       repeats: false)
            RunLoop.main.add(self._deallocTimer!, forMode: .common)
        }
    }

    public func onDealloc(_ handler: (([DysprosiumObject]) -> Void)?) {
        _onDealloc = handler
    }

    public func onExpectedDeallocation(_ handler: ((DysprosiumObject, String) -> Void)?) {
        _onExpectedDeallocation = handler
    }

    public func expectDeallocation<T: DysprosiumCompatible>(of viewController: T,
                                                            after timeInterval: TimeInterval = 2.0)
        where T: UIViewController {
            if !isEnabled {
                return
            }

            var rootParentViewController: UIViewController = viewController
            while let parent = rootParentViewController.parent {
                rootParentViewController = parent
            }

            if viewController.isMovingFromParent || rootParentViewController.isBeingDismissed {
                let disappearanceSource = "after being " +
                    (viewController.isMovingFromParent ? "removed from its parent" : "dismissed")

                expectDeallocation(of: viewController,
                                   after: timeInterval,
                                   message: disappearanceSource)
            }
    }

    public func expectDeallocation(of obj: DysprosiumCompatible,
                                   after timeInterval: TimeInterval,
                                   message: String? = nil) {
        if !isEnabled {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak obj] in
            guard let obj = obj else {
                return
            }
            let memoryName = self.getMemoryName(of: obj)
            let deallocModel = DysprosiumObject(className: String(describing: type(of: obj)), memoryName: memoryName)
            self._onExpectedDeallocation?(deallocModel, message ?? "")
        }
    }

    @objc
    fileprivate func _deallocatedTimerFinished(timer: Timer) {
        _lockQueue.sync {
            if self._deallocatedObjects.isEmpty { return }
            self._deallocTimer = nil
            self._onDealloc?(self._deallocatedObjects)

            self._deallocatedObjects.removeAll()
        }
    }

    // MARK: - Private helper functions
    // _________________________________________________________________________________________________________________


    func getMemoryName<T: DysprosiumCompatible>(of object: T) -> String {
        let addr = unsafeBitCast(object, to: Int.self)
        return String(format: "%p", addr)
    }
}
