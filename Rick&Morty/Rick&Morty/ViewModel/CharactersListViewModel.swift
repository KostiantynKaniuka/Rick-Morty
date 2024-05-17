//
//  CharactersListViewModel.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation
import Combine

final class CharactersListViewModel {
    private var networkManager: NetworkManager
    private var allCharacters = [Character]()
    private(set) var displayedCharacters = CurrentValueSubject<[Character], Never>([])
    private(set) var isLoading = PassthroughSubject<Bool, Never>()
    private(set) var fetchedError = PassthroughSubject<Error, Never>()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func showCharacters() {
        fetchProducts()
    }
}


private extension CharactersListViewModel {
    
    func fetchProducts() {
        let charactersURL = EndPoint.allCharacters.url
        networkManager.getRequest(with: charactersURL) { [weak self] (response: Result<Characters, Error>) in
            guard let self = self else {return}
            self.isLoading.send(false)
            switch response {
            case .success(let response):
                self.allCharacters = response.results
                self.displayedCharacters.send(self.allCharacters)
                print("✅")
                return
            case .failure(let error):
                self.fetchedError.send(error)
                print(error)
            }
            return
        }
    }
}

