//
//  DysprosiumObject.swift
//  Dysprosium
//
//  Created by Bas van Kuijck on 12/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol DysprosiumCompatible: AnyObject { }

extension DysprosiumCompatible where Self: UIViewController {
    public func expectDeallocation(after timeinterval: TimeInterval = 2.0) {
        Dysprosium.shared.expectDeallocation(of: self, after: timeinterval)
    }
}

extension DysprosiumCompatible {
    public func expectDeallocation(after timeinterval: TimeInterval = 2.0) {
        Dysprosium.shared.expectDeallocation(of: self, after: timeinterval)
    }

    public func deallocated() {
        Dysprosium.shared.deallocated(object: self)
    }
}
