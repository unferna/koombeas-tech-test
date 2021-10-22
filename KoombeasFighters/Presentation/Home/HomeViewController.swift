//
//  HomeViewController.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.24), blur: 4, position: CGPoint(x: 0, y: 6))
        
        setupTable()
    }
    
    func setupTable() {
        tableView.register(UniverseSelectorTableViewCell.self)
        tableView.register(FighterTableViewCell.self)
        
        var currentInset = tableView.contentInset
        currentInset.top = 60
        
        tableView.contentInset = currentInset
    }
    
    @IBAction func didTapFilters(_ sender: UIButton) {
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusable(for: indexPath) as UniverseSelectorTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusable(for: indexPath) as FighterTableViewCell
        return cell
    }
}
