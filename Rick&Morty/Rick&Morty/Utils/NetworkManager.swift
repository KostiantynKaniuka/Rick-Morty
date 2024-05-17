//
//  NetworkManager.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation
import Combine


final class NetworkManager {
    private var subscribers = Set<AnyCancellable>()

    func getRequest<T: Decodable>(with url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlComponents = URLComponents(string: url.absoluteString) else { return }
        
        URLSession.shared
            .dataTaskPublisher(for: urlComponents.url!)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { (response) in
                switch response {
                case .failure(let error):
                    completion(.failure(error))
                case .finished: break
                }
            }, receiveValue: { (response) in
                completion(.success(response))
            })
            .store(in: &subscribers)
    }
}
