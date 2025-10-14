//
//  ABView.swift
//  AccountCreationKit
//

import SwiftUI

public protocol ABView: View {
    associatedtype ViewModel: ABViewModel
    associatedtype ListBody: View

    var viewModel: ViewModel { get }
    @ViewBuilder var listBody: ListBody { get }
}

extension ABView {
    @ViewBuilder
    public var body: some View {
        listBody
    }
}
