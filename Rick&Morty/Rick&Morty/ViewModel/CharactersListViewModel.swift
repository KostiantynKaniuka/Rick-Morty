//
//  CharactersListViewModel.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation
import Combine

private enum LoadingInitiator {
    case initialStart
    case refetch
}

final class CharactersListViewModel {
    private var networkManager: NetworkManager
    private var allCharacters = [Character]()
    private var loadingInitiator: LoadingInitiator = .initialStart // for managing loading indicators state
    private(set) var displayedCharacters = CurrentValueSubject<[Character], Never>([])
    private(set) var isLoading = PassthroughSubject<Bool, Never>()
    private(set) var fetchedError = PassthroughSubject<Error, Never>()
    private(set) var listHeaderName = "Characters"
    
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func showCharacters() {
        fetchProducts()
    }
}

private extension CharactersListViewModel {
    
    func fetchProducts() {
        switch loadingInitiator {
        case .initialStart:
            isLoading.send(true)
        case .refetch: break
        }
        
        let charactersURL = EndPoint.allCharacters.url
       
        networkManager.getRequest(with: charactersURL) { [weak self] (response: Result<Characters, Error>) in
            guard let self = self else {return}
            self.isLoading.send(false)
            switch response {
            case .success(let response):
                self.isLoading.send(false)
                self.allCharacters = response.results
                self.displayedCharacters.send(self.allCharacters)
                self.loadingInitiator = .refetch
                print("✅")
                return
            case .failure(let error):
                self.loadingInitiator = .refetch
                self.isLoading.send(false)
                self.fetchedError.send(error)
                print(error)
            }
            return
        }
    }
}

