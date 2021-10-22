//
//  OnboardingSlideCollectionViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class OnboardingSlideCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageSlideView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(_ image: UIImage) {
        imageSlideView.image = image
    }
}
