//
//  CollectionExtension.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 16..
//

import Foundation

// Copied from here for now: https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
// but I also used it in my companies source

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
