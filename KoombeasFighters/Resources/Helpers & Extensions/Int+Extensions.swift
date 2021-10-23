//
//  Int+Extensions.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import Foundation

extension Int {
    func withCommas() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
