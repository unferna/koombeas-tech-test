//
//  FilterViewController.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 23/10/21.
//

import UIKit

protocol FilterViewControllerDelegate: NSObjectProtocol {
    func applyFilters(criteria: SortItemsData, rate: Int)
}

enum SortItemsData: String {
    case none
    case name = "Name"
    case price = "Price"
    case rate = "Rate"
    case downloads = "Downloads"
}

class FilterViewController: UIViewController {
    @IBOutlet weak var sortByTableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    let sortByData: [SortItemsData] = [
        .name,
        .price,
        .rate,
        .downloads
    ]
    
    var selectedItem = 0
    var seletedRate = 0
    
    weak var delegate: FilterViewControllerDelegate?
    var currentFilter: (sorting: SortItemsData, rate: Int) = (sorting: .name, rate: 0)
    
    let yellowColor = UIColor(named: "starYellowColor")
    var normalStarColor: UIColor!
    var shouldUpdateHome = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFilters()
        
        setupTableView()
        setupStars()
        fillStars(selection: seletedRate)
        
        resetButton.circle(customRadius: 6)
        applyButton.circle(customRadius: 6)
        
        resetButton.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        resetButton.layer.borderWidth = 1
        
        applyButton.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        applyButton.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldUpdateHome {
            let itemSelected = sortByData[selectedItem]
            delegate?.applyFilters(criteria: itemSelected, rate: seletedRate)
        }
    }
    
    @IBAction func didTapReset(_ sender: UIButton) {
        selectedItem = 0
        seletedRate = 0
        
        fillStars(selection: 0)
        sortByTableView.selectRow(at: IndexPath(row: selectedItem, section: 0), animated: false, scrollPosition: .top)
        
        delegate?.applyFilters(criteria: .none, rate: seletedRate)
        shouldUpdateHome = false
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapApply(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func didTapStar(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        seletedRate = tag
        
        fillStars(selection: tag)
    }
    
    func loadFilters() {
        selectedItem = sortByData.firstIndex(of: currentFilter.sorting) ?? 0
        seletedRate = currentFilter.rate
    }
    
    func setupTableView() {
        sortByTableView.register(SortByItemTableViewCell.self)
        sortByTableView.selectRow(at: IndexPath(row: selectedItem, section: 0), animated: false, scrollPosition: .top)
    }
    
    func fillStars(selection: Int) {
        starImageView1.tintColor = selection >= 1 ? yellowColor : normalStarColor
        starImageView2.tintColor = selection >= 2 ? yellowColor : normalStarColor
        starImageView3.tintColor = selection >= 3 ? yellowColor : normalStarColor
        starImageView4.tintColor = selection >= 4 ? yellowColor : normalStarColor
        starImageView5.tintColor = selection >= 5 ? yellowColor : normalStarColor
    }
    
    func setupStars() {
        starImageView1.tag = 1
        starImageView2.tag = 2
        starImageView3.tag = 3
        starImageView4.tag = 4
        starImageView5.tag = 5
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        starImageView1.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        starImageView2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        starImageView3.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        starImageView4.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        starImageView5.addGestureRecognizer(gesture5)
        
        normalStarColor = starImageView1.tintColor
        
        starImageView1.image = starImageView1.image?.withRenderingMode(.alwaysTemplate)
        starImageView2.image = starImageView2.image?.withRenderingMode(.alwaysTemplate)
        starImageView3.image = starImageView3.image?.withRenderingMode(.alwaysTemplate)
        starImageView4.image = starImageView4.image?.withRenderingMode(.alwaysTemplate)
        starImageView5.image = starImageView5.image?.withRenderingMode(.alwaysTemplate)
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortByData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(for: indexPath) as SortByItemTableViewCell
        let item = sortByData[indexPath.row]
        cell.setItemName(item.rawValue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
    }
}
