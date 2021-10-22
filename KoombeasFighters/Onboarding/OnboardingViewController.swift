//
//  OnboardingViewController.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var slidesCollection: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupCollection()
        
        let doneButtonWidth = doneButton.bounds.width
        doneButton.layer.cornerRadius = doneButtonWidth / 2
        doneButton.alpha = 0
    }
    
    private let sizeItem = CGSize(width: 300, height: 350)
    
    private let slidesInfo: [(text: String, image: UIImage)] = [
        (text: "Access our\nExtended Catalog", image: UIImage(named: "onboardingPic1")!),
        (text: "Filter Fighters", image: UIImage(named: "onboardingPic2")!),
        (text: "And more...", image: UIImage(named: "onboardingPic3")!),
    ]
    
    func setupCollection() {
        slidesCollection.register( OnboardingSlideCollectionViewCell.self )
        
        slidesCollection.delegate = self
        slidesCollection.dataSource = self
        
        slidesCollection.showsVerticalScrollIndicator = false
        slidesCollection.showsHorizontalScrollIndicator = false
        slidesCollection.allowsMultipleSelection = false
        slidesCollection.isPagingEnabled = false
        
        let customLayout = CarouselCollectionLayout()
        customLayout.scrollDirection = .horizontal
        customLayout.minimumInteritemSpacing = 16
        customLayout.minimumLineSpacing = 16
        customLayout.itemSize = sizeItem
        customLayout.currentPage = .zero
        slidesCollection.collectionViewLayout = customLayout
        slidesCollection.decelerationRate = .fast
    }
    
    @IBAction func didPageChanged(_ sender: UIPageControl) {
        let target = IndexPath(row: sender.currentPage, section: 0)
        
        slidesCollection.scrollToItem(at: target, at: .left, animated: true)
        (slidesCollection.collectionViewLayout as? CarouselCollectionLayout)?.currentPage = target.row
        
        toggleDoneButton(show: target.row == slidesInfo.count - 1)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        print("Did tap done")
    }
    
    func toggleDoneButton(show: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.doneButton.alpha = show ? 1 : 0
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slidesInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(for: indexPath) as OnboardingSlideCollectionViewCell
        
        let itemInfo = slidesInfo[indexPath.row]
        cell.setImage(itemInfo.image)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let layout = slidesCollection.collectionViewLayout as? CarouselCollectionLayout {
            let index = layout.currentPage
            descriptionLabel.text = slidesInfo[index].text
            pageControl.currentPage = index
            
            toggleDoneButton(show: index == slidesInfo.count - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 350)
    }
}
