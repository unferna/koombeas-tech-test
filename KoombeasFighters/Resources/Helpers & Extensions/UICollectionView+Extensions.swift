//
//  UICollectionView+Extensions.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

extension UICollectionView {
    func register<T>(_ type: T.Type) where T: UICollectionViewCell {
        let cellName = String(describing: T.self)
        
        let nibCell = UINib(nibName: cellName, bundle: nil)
        register(nibCell, forCellWithReuseIdentifier: cellName)
    }
    
    func dequeueReusable<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        let cellName = String(describing: T.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with Identifier: \(cellName).")
        }
        
        return cell
    }
}
