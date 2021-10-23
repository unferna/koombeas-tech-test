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
    
    var universes: [Universe] = []
    var fighters: [Fighter] = []
    
    private lazy var presenter: HomePresenter = {
        return HomePresenter(withView: self)
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.24), blur: 4, position: CGPoint(x: 0, y: 6))
        
        setupTable()
        reloadData()
    }
    
    func setupTable() {
        tableView.register(UniverseSelectorTableViewCell.self)
        tableView.register(FighterTableViewCell.self)
        
        var currentInset = tableView.contentInset
        currentInset.top = 60
        
        tableView.contentInset = currentInset
    }
    
    func reloadData() {
        presenter.loadData()
    }
    
    @IBAction func didTapFilters(_ sender: UIButton) {
        
    }
}

extension HomeViewController: HomeView {
    func fightersFiltered(fighters: [Fighter]) {
        self.fighters = fighters
        tableView.reloadSections([1], with: .automatic)
    }
    
    func homeLoaded(universes: [Universe], fighters: [Fighter]) {
        self.universes = universes
        self.fighters = fighters
        tableView.reloadData()
    }
    
    func showError(error: GeneralError) {
        
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
        
        return fighters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusable(for: indexPath) as UniverseSelectorTableViewCell
            cell.delegate = self
            cell.setUniverses(universes)
            
            return cell
        }
        
        let fighter = fighters[indexPath.row]
        let cell = tableView.dequeueReusable(for: indexPath) as FighterTableViewCell
        cell.setFighter(fighter)
        return cell
    }
}

extension HomeViewController: UniverseSelectorTableViewCellDelegate {
    func didUniverseSelected(at indexPath: IndexPath) {
        if let universe = universes[safe: indexPath.row] {
            presenter.filterFighters(by: .universe, withValue: universe.name)
        }
    }
}
