//
//  FighterDetailViewController.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit
import Kingfisher
import Combine

class FighterDetailViewController: UIViewController {
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universeLabel: UILabel!
    @IBOutlet weak var fighterImageView: UIImageView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var noInternetWarningView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let networkMonitor = NetworkMonitor.shared
    private var cancellable: Cancellable!
    
    var fighter: Fighter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleViewLabel.text = "Fighters"
        
        cancellable = networkMonitor.publisherNetworkAvailable
            .receive(on: DispatchQueue.main)
            .assign(to: \.isHidden, on: noInternetWarningView)
        
        noInternetWarningView.isHidden = networkMonitor.isReachable
        
        loadData()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        nameLabel.text = fighter.name
        universeLabel.text = fighter.universe
        
        if let imageURL = URL(string: fighter.imageURL) {
            let imageResource = ImageResource(downloadURL: imageURL)
            
            fighterImageView.kf.setImage(with: imageResource)
        }
        
        let normalTint = starImageView1.tintColor
        let yellowColor = UIColor(named: "starYellowColor")
        
        starImageView1.image = starImageView1.image?.withRenderingMode(.alwaysTemplate)
        starImageView2.image = starImageView2.image?.withRenderingMode(.alwaysTemplate)
        starImageView3.image = starImageView3.image?.withRenderingMode(.alwaysTemplate)
        starImageView4.image = starImageView4.image?.withRenderingMode(.alwaysTemplate)
        starImageView5.image = starImageView5.image?.withRenderingMode(.alwaysTemplate)
        
        starImageView1.tintColor = fighter.rate >= 1 ? yellowColor : normalTint
        starImageView2.tintColor = fighter.rate >= 2 ? yellowColor : normalTint
        starImageView3.tintColor = fighter.rate >= 3 ? yellowColor : normalTint
        starImageView4.tintColor = fighter.rate >= 4 ? yellowColor : normalTint
        starImageView5.tintColor = fighter.rate >= 5 ? yellowColor : normalTint
        
        if let downloads = Int(fighter.downloads)?.withCommas() {
            downloadsLabel.text = "Downloads: " + downloads
        }
        
        priceContainerView.circle(customRadius: 6.86)
        
        if let price = Int(fighter.price)?.withCommas() {
            priceLabel.text = "$" + price
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        paragraph.lineHeightMultiple = 1.62
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph
        ]
        
        descriptionLabel.attributedText = NSMutableAttributedString(string: fighter.description, attributes: attributes)
    }
    
    deinit {
        cancellable.cancel()
    }
}
