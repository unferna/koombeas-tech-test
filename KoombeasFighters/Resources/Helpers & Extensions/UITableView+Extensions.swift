//
//  UITableView+Extensions.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

extension UITableView {
    func register<T>(_ type: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        
        let nibCell = UINib.init(nibName: cellName, bundle: nil)
        register(nibCell, forCellReuseIdentifier: cellName)
    }
    
    func dequeueReusable<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        let cellName = String(describing: T.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with Identifier: \(cellName).")
        }
        
        return cell
    }
}
