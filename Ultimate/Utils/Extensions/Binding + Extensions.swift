//
//  Binding + Extensions.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 12.04.2022.
//

import SwiftUI

extension Binding {
    func onChange(_ completion: @escaping () -> Void) -> Binding<Value> {
        return Binding {
            self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
            completion()
        }

    }
}
