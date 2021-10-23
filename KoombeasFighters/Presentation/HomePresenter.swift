//
//  HomePresenter.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

protocol HomeView {
    func homeLoaded(universes: [Universe], fighters: [Fighter])
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
            DispatchQueue.main.async {
                self?.view?.showError(error: error)
            }
        })
    }
}
