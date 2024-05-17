//
//  EndPoint.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation


import Foundation

enum EndPoint: String {
    case allCharacters = "https://rickandmortyapi.com/api/character"

    var url: URL{
        URL(string: self.rawValue)!
    }

}
