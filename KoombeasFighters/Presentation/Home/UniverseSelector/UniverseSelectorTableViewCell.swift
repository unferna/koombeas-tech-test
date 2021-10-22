//
//  UniverseSelectorTableViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class UniverseSelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var universesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollection()
    }
    
    let hardDataSource = ["All", "Donkey Kong", "The Legend Of Zelda", "Donkey Kong", "The Legend Of Zelda"]
    
    func setupCollection() {
        universesCollectionView.register(UniverseCollectionViewCell.self)
        universesCollectionView.isPagingEnabled = false
        universesCollectionView.showsHorizontalScrollIndicator = false
        universesCollectionView.dataSource = self
        universesCollectionView.delegate = self
        
        if let flowLayout = universesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 5, right: 16)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            
            universesCollectionView.collectionViewLayout = flowLayout
        }
    }
}

extension UniverseSelectorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hardDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(for: indexPath) as UniverseCollectionViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.setName(hardDataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = hardDataSource[indexPath.row]
        var baseWidth = 74
        
        if name.count > 10 {
            baseWidth = 160
        
        } else if name.count > 5 {
            baseWidth = 110
        }
        
        return CGSize(width: baseWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected")
        print(indexPath)
    }
}

extension UniverseSelectorTableViewCell: UniverseCollectionViewCellDelegate {
    func didTapUniverse(at: IndexPath) { }
}
