//
//  Mockable.swift
//  Rick&MortyTests
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle {get}
    func loadJSON<T: Decodable>(fileName: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(fileName: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("fail to load JSON")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            
            return decodedObject
        } catch {
            print("❌ \(error)")
            fatalError("failed to decode the JSON")
        }
    }
    
}
