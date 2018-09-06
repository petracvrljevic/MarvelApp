//
//  CharacterListTableViewController.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD
import CryptoSwift

class CharacterListTableViewController: UITableViewController {
    
    var isLoading = false
    let limit = 20
    var offSet = 0
    
    private var viewModel: CharacterListViewModel = CharacterListViewModel() {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "marvelCell")
        
        downloadCharacters()
    }
    
    private func downloadCharacters() {
        
        if let request = createRequest() {
            
            var downloadedCharacters = viewModel.characters
            
            let progressNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressNotification.isUserInteractionEnabled = false
            
            Webservice().getCharacters(url: request) { (characters) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let chars = characters.map { character in
                    return CharacterViewModel(character: character)
                }
                
                var duplicate = false
                
                for char in chars {
                    for dc in downloadedCharacters {
                        if char.id == dc.id {
                            duplicate = true
                        }
                    }
                }
                
                if !duplicate {
                    downloadedCharacters.append(contentsOf: chars)
                }
                
                self.offSet += chars.count
                self.viewModel = CharacterListViewModel(chars: downloadedCharacters)
                self.isLoading = false
            }
            
            
        }
    }
    
    func createRequest() -> URLRequest? {
        let webService = Webservice()
        if let dict = webService.getApiKeys() {
            
            let hash = (dict.ts + dict.privateKey + dict.publicKey).md5()
            
            let url = dict.url
            let params = ["apikey": dict.publicKey,
                          "ts": "\(dict.ts)",
                          "hash": hash,
                          "limit": "\(limit)",
                          "offset": "\(offSet)"] as [String : String]
            
            
            var items = [URLQueryItem]()
            var apiURL = URLComponents(string: url)
            for (key, value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
            apiURL?.queryItems = items
            if let apiURL = apiURL?.url {
                let request = URLRequest(url: apiURL)
                return request
            }
            
        }
        return nil
    }
}

extension CharacterListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.characters.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marvelCell", for: indexPath) as! CharacterTableViewCell
        
        let characterViewModel = self.viewModel.characters[indexPath.row]
        if let url = URL(string: characterViewModel.imageURL + "/portrait_small.\(characterViewModel.imageExtension)") {
            cell.characterImageView.kf.setImage(with: url, placeholder: UIImage(named: "nooimage"), options: nil, progressBlock: nil, completionHandler: nil
            )
        }
        cell.nameLabel.text = characterViewModel.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let total = viewModel.characters.count
        if (indexPath.row + 1 == total && isLoading == false) {
            isLoading = true
            downloadCharacters()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterViewModel = self.viewModel.characters[indexPath.row]
        let detailVC = CharacterDetailsViewController()
        detailVC.characterDetailViewModel = CharacterDetailViewModel(characterViewModel: characterViewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
