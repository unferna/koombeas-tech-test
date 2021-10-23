//
//  UniverseCollectionViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

protocol UniverseCollectionViewCellDelegate: NSObjectProtocol {
    func didTapUniverse(at: IndexPath)
}

class UniverseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var universeNameLabel: UILabel!
    
    weak var delegate: UniverseCollectionViewCellDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circle(customRadius: 2)
    }
    
    func setName(_ name: String) {
        universeNameLabel.text = name
    }

    @IBAction func didTapUniverse(_ sender: UIButton) {
        delegate?.didTapUniverse(at: indexPath)
    }
    
    func setSelected(_ seleted: Bool) {
        backgroundColor = seleted ? UIColor(named: "darkColor") : UIColor(named: "mainColor")
        isSelected = true
    }
}
