//
//  Array+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 26.07.2024.
//

import Foundation

//MARK: - Arrays
public extension Collection where Indices.Iterator.Element == Index {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
