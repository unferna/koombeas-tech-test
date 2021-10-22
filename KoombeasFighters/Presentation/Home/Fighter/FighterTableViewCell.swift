//
//  FighterTableViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class FighterTableViewCell: UITableViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
