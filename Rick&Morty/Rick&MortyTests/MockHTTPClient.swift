//
//  MockHTTPClient.swift
//  Rick&MortyTests
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation
@testable import Rick_Morty

final class MockHTTPClient: HTTPClientProtocol, Mockable {
    
    func getRequest<T>(with url: URL, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let result: Result<T, Error> = Result {
            loadJSON(fileName: "CharacterResponse", type: T.self)
           }
           
           completion(result)
       }
       
    }
