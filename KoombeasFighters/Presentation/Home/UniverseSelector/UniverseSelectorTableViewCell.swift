//
//  UniverseSelectorTableViewCell.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

protocol UniverseSelectorTableViewCellDelegate: NSObjectProtocol {
    func didUniverseSelected(at indexPath: IndexPath)
}

class UniverseSelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var universesCollectionView: UICollectionView!
    weak var delegate: UniverseSelectorTableViewCellDelegate?
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollection()
    }
    
    private var universes: [Universe] = []
    
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
    
    func setUniverses(_ universes: [Universe], selected: String = "") {
        self.universes = universes
        
        universesCollectionView.reloadData()
        
        if !selected.isEmpty {
            if let indexOfSelected = universes.firstIndex(where: { $0.name == selected }) {
                let target = IndexPath(row: indexOfSelected, section: 0)
                selectedIndex = target
                
                delay(time: 0.8) { [weak self] in
                    self?.universesCollectionView.scrollToItem(at: target, at: .right, animated: true)
                    self?.delay(time: 0.2) {
                        self?.selectCell(at: target)
                    }
                }
            }
        } else {
            delay(time: 0.5) { [weak self] in
                self?.selectCell(at: self?.selectedIndex ?? IndexPath(row: 0, section: 0))
            }
        }
    }
    
    func selectCell(at indexPath: IndexPath) {
        if let cell = universesCollectionView.cellForItem(at: indexPath) as? UniverseCollectionViewCell {
            cell.setSelected(true)
            universesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    func delay(time: TimeInterval, completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            completion()
        }
    }
}

extension UniverseSelectorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return universes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(for: indexPath) as UniverseCollectionViewCell
        cell.indexPath = indexPath
        cell.setName(universes[indexPath.row].name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = universes[indexPath.row].name
        var baseWidth = 74
        
        if name.count > 10 {
            baseWidth = 160
        
        } else if name.count > 5 {
            baseWidth = 110
        }
        
        return CGSize(width: baseWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didUniverseSelected(at: indexPath)
        selectedIndex = indexPath
        (collectionView.cellForItem(at: indexPath) as? UniverseCollectionViewCell)?.setSelected(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UniverseCollectionViewCell {
            cell.setSelected(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var shouldSelect = true
        if selectedIndex != indexPath {
            shouldSelect = false
        
        } else {
            shouldSelect = true
            selectedIndex = IndexPath(row: 0, section: 0)
        }
        
        if shouldSelect {
            let item = cell as? UniverseCollectionViewCell
            item?.setSelected(item?.isSelected ?? false)
        }
    }
}
