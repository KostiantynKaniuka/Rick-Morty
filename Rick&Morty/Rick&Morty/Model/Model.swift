//
//  Model.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let image: String
    let type: String
    let gender: String
}


struct Characters: Codable {
    let results: [Character]
}
