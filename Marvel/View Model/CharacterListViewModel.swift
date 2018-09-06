//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import Foundation

struct CharacterListViewModel {
    
    var characters: [CharacterViewModel] = [CharacterViewModel]()
    
}

extension CharacterListViewModel {
    
    init(chars: [CharacterViewModel]) {
        self.characters = chars
    }
}

struct CharacterViewModel {
    
    var id: Int
    var imageURL: String
    var imageExtension: String
    var name: String
    var wikiURL: String

}

extension CharacterViewModel {
    init(character: Character) {
        
        self.id = character.id
        
        let wikiURL = character.urls.first { (url) -> Bool in
            return url.type == "wiki"
        }
        if let url = wikiURL {
            self.wikiURL = url.url
        }
        else {
            self.wikiURL = ""
        }
        
        self.imageExtension = character.thumbnail.ex
        
        self.imageURL = character.thumbnail.path
        
        self.name = character.name
    }
}


