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
    
    private let refreshControl = UIRefreshControl()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var universes: [Universe] = []
    var fighters: [Fighter] = []
    
    var currentFilter: (sorting: SortItemsData, rate: Int) = (sorting: .none, rate: 0)
    
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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    func reloadData() {
        presenter.loadData()
    }
    
    @IBAction func didTapFilters(_ sender: UIButton) {
        let filtersStoryboard = UIStoryboard(name: "FilterViewController", bundle: nil)
        let filterVC = filtersStoryboard.instantiateInitialViewController() as! FilterViewController
        
        filterVC.delegate = self
        filterVC.currentFilter = currentFilter
        present(filterVC, animated: true)
    }
    
    @objc func refresh(_ any: UIRefreshControl) {
        reloadData()
    }
    
    func sortFighters() {
        switch currentFilter.sorting {
            case .name:
                fighters.sort {
                    $0.name < $1.name
                }
            
            case .price:
                fighters.sort {
                    guard
                        let price1 = Int($0.price),
                        let price2 = Int($1.price)
                    else { return false }
                    
                    return price1 < price2
                }
                
            case .rate:
                fighters.sort {
                    $0.rate < $1.rate
                }
                
            case .downloads:
                fighters.sort {
                    guard
                        let downloads1 = Int($0.downloads),
                        let downloads2 = Int($1.downloads)
                    else { return false }
                    
                    return downloads1 < downloads2
                }
            case .none:
                break
        }
    }
}

extension HomeViewController: HomeView {
    func fightersFiltered(fighters: [Fighter]) {
        self.fighters = fighters
        sortFighters()
        tableView.reloadSections([1], with: .automatic)
    }
    
    func homeLoaded(universes: [Universe], fighters: [Fighter]) {
        self.universes = universes
        self.fighters = fighters
        tableView.reloadData()
        refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fighter = fighters[safe: indexPath.row] else { return }
        
        let detailsStoryboard = UIStoryboard(name: "FighterDetailViewController", bundle: nil)
        let detailsVC = detailsStoryboard.instantiateInitialViewController() as! FighterDetailViewController
        
        detailsVC.fighter = fighter
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension HomeViewController: UniverseSelectorTableViewCellDelegate {
    func didUniverseSelected(at indexPath: IndexPath) {
        if let universe = universes[safe: indexPath.row] {
            presenter.filterFighters(by: .universe, withValue: universe.name)
            currentFilter = (sorting: .none, rate: 0)
        }
    }
}

extension HomeViewController: FilterViewControllerDelegate {
    func applyFilters(criteria: SortItemsData, rate: Int) {
        currentFilter = (sorting: criteria, rate: rate)
        
        // Reset
        if criteria == .none {
            presenter.filterFighters(by: .universe, withValue: "All")
        }
        
        if rate > 0 {
            presenter.filterFighters(by: .rate, withValue: String(rate))
        
        } else {
            sortFighters()
            tableView.reloadSections([1], with: .automatic)
        }
    }
}
