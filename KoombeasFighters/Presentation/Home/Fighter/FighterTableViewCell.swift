//
//  FighterTableViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit
import Kingfisher

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gameImageView.image = nil
        gameImageView.backgroundColor = UIColor(named: "mainColor")
    }
    
    func setFighter(_ fighter: Fighter) {
        if let imageUrl = URL(string: fighter.imageURL) {
            let imageResource = ImageResource(downloadURL: imageUrl)
            gameImageView.kf.setImage(with: imageResource) { [weak self] _ in
                self?.gameImageView.backgroundColor = .clear
            }
        }
        
        nameLabel.text = fighter.name
        universeLabel.text = fighter.universe
        
        if let price = Int(fighter.price)?.withCommas() {
            priceLabel.text = "Price: $" + price
        }
        
        rateLabel.text = String("Rate: \(fighter.rate)")
        
        if let downloads = Int(fighter.downloads)?.withCommas() {
            downloadsLabel.text = "Downloads: " + downloads
        }
    }
}
