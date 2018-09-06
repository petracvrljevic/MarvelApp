//
//  Webservice.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

struct ApiDict {
    let url: String
    let publicKey: String
    let privateKey: String
    let ts: String
}

class Webservice {
    
    private var api: NSDictionary?
    
    func getApiKeys() -> ApiDict? {
        if let path = Bundle.main.path(forResource: "api", ofType: "plist") {
            self.api = NSDictionary(contentsOfFile: path)
        }
        
        if let data = api {
            return ApiDict(url: data["url"] as! String, publicKey: data["publicKey"] as! String, privateKey: data["privateKey"] as! String, ts: data["ts"] as! String)
        }
        else {
            return nil
        }
    }

    func getCharacters(url: URLRequest, callback: @escaping ([Character]) -> ()) {
        
        var characters = [Character]()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(CharacterList.self, from: data)
                    characters = result.data.results
                }
                catch {
                    print("Error: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                callback(characters)
            }
        }.resume()
        
    }
    
}
