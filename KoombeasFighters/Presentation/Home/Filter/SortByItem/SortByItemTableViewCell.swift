//
//  SortByItemTableViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 23/10/21.
//

import UIKit

class SortByItemTableViewCell: UITableViewCell {
    @IBOutlet weak var selectorIndicatorContainerView: UIView!
    @IBOutlet weak var selectorIndicatorView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupIndicator()
    }
    
    func setupIndicator() {
        selectorIndicatorView.isHidden = true
        selectorIndicatorContainerView.circle()
        selectorIndicatorView.circle()
        
        selectorIndicatorContainerView.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        selectorIndicatorContainerView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectorIndicatorView.isHidden = !selected
    }
    
    func setItemName(_ name: String) {
        itemNameLabel.text = name
    }
}
