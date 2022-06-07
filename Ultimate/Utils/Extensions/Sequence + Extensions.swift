//
//  Sequence + Extensions.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 07.05.2022.
//

import Foundation
import UIKit

extension Sequence {
    func sort<Value: Comparable>(by keyPath: KeyPath<Element,Value>) -> [Element] {
        return self.sorted {
            $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }
}
