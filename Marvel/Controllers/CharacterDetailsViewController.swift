//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher
import MBProgressHUD

class CharacterDetailsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var wikiButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    
    var characterDetailViewModel : CharacterDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        
        let character = characterDetailViewModel.characterViewModel

        if let url = URL(string: character.imageURL + "/landscape_small.\(character.imageExtension)") {
            characterImageView.kf.setImage(with: url, placeholder: UIImage(named: "nooimage"), options: nil, progressBlock: nil, completionHandler: nil
            )
        }
        
        characterName.text = character.name
        wikiButton.setTitle("Open wiki", for: .normal)
    }

    @IBAction func openWiki(_ sender: UIButton) {
        let progressNavigation = MBProgressHUD.showAdded(to: webView, animated: true)
        progressNavigation.isUserInteractionEnabled = false
        if let url = URL(string: characterDetailViewModel.characterViewModel.wikiURL) {
            print(url)
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: webView, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hide(for: webView, animated: true)
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
