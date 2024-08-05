//
//  String+Extensions.swift
//
//
//  Created by Ezgi Sümer Günaydın on 5.08.2024.
//

import Foundation

public extension String {
    func capitalizingEachWord() -> String {
        return self.split(separator: " ").map { String($0).capitalizingFirstLetter() }.joined(separator: " ")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    mutating func capitalizeEachWord() {
        self = self.capitalizingEachWord()
    }
}
