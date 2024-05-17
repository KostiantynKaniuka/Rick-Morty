//
//  NetworkManager.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation
import Combine

protocol HTTPClientProtocol {
    func getRequest<T: Decodable>(with url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkManager: HTTPClientProtocol {
    private var subscribers = Set<AnyCancellable>()
    
    private lazy var session: URLSession = {
           let configuration = URLSessionConfiguration.default
           configuration.requestCachePolicy = .reloadIgnoringLocalCacheData 
           return URLSession(configuration: configuration)
       }()

    func getRequest<T: Decodable>(with url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlComponents = URLComponents(string: url.absoluteString) else { return }
       
        session
            .dataTaskPublisher(for: urlComponents.url!)
            .tryMap { data, response in
                          guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                              throw URLError(.badServerResponse)
                          }
                          return data
                      }
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
