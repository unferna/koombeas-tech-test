//
//  Collection+Extensions.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
