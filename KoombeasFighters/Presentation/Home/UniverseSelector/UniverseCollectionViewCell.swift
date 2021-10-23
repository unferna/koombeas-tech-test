//
//  UniverseCollectionViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class UniverseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var universeNameLabel: UILabel!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circle(customRadius: 2)
    }
    
    func setName(_ name: String) {
        universeNameLabel.text = name
        setSelected(false)
    }
    
    func setSelected(_ seleted: Bool) {
        backgroundColor = seleted ? UIColor(named: "darkColor") : UIColor(named: "mainColor")
        isSelected = true
    }
}
