//
//  Character.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import Foundation

class CharacterList: Codable {
    var data: CharacterListResults
}

class CharacterListResults: Codable {
    var results: [Character]
}

class Character: Codable {
    
    var id: Int
    var name: String
    var thumbnail: Thumbnail
    var urls: [Urls]
    
    init(id: Int, name: String, thumbnail: Thumbnail, urls: [Urls]) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.urls = urls
    }
}

class Thumbnail: Codable {
    var path: String
    var ex: String
    
    init(path: String, ex: String) {
        self.path = path
        self.ex = ex
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case ex = "extension"
    }
    
}

class Urls: Codable {
    var type: String
    var url: String
    
    init(type: String, url: String) {
        self.type = type
        self.url = url
    }
}
