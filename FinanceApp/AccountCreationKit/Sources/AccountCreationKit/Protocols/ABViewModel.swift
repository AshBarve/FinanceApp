//
//  ABViewModel.swift
//  AccountCreationKit
//

import SwiftUI

public protocol ABViewModel {
    var screenTitle: String? { get }

    func submitCompleteHandler()
}
