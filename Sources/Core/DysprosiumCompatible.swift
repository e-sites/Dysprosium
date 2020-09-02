//
//  DysprosiumObject.swift
//  Dysprosium
//
//  Created by Bas van Kuijck on 12/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation
import UIKit

public protocol DysprosiumCompatible: class { }

public extension DysprosiumCompatible where Self: UIViewController {
    func expectDeallocation(after timeinterval: TimeInterval = 2.0) {
        Dysprosium.shared.expectDeallocation(of: self, after: timeinterval)
    }
}

public extension DysprosiumCompatible {
    func expectDeallocation(after timeinterval: TimeInterval = 2.0) {
        Dysprosium.shared.expectDeallocation(of: self, after: timeinterval)
    }

    func deallocated() {
        Dysprosium.shared.deallocated(object: self)
    }
}
