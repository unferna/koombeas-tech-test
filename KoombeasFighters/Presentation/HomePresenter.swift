//
//  HomePresenter.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

protocol HomeView {
    func homeLoaded(universes: [Universe], fighters: [Fighter])
    func fightersFiltered(fighters: [Fighter])
    func showError(error: GeneralError)
}

class HomePresenter {
    var view: HomeView?
    
    init(withView view: HomeView) {
        self.view = view
    }
    
    func loadData() {
        HomeDataService.shared.loadHome(completion: { [weak self] (universes, fighters) in
            DispatchQueue.main.async {
                self?.view?.homeLoaded(universes: universes, fighters: fighters)
            }
            
        }, failure: { [weak self] (error) in
            self?.showError(error)
        })
    }
    
    func filterFighters(by filter: FighterFilter, withValue: String) {
        if filter == .rate || filter == .universe {
            var filterToUse = filter
            var valueToUse = withValue
            
            if filter == .universe && withValue == "All" {
                filterToUse = .all
                valueToUse = ""
            }
            
            HomeDataService.shared.getFighters(filteredBy: filterToUse, withValue: valueToUse, completion: { [weak self] (fighters) in
                DispatchQueue.main.async {
                    self?.view?.fightersFiltered(fighters: fighters)
                }
                
            }, failure: { [weak self] (error) in
                self?.showError(error)
            })
        }
    }
    
    private func showError(_ error: GeneralError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(error: error)
        }
    }
}
