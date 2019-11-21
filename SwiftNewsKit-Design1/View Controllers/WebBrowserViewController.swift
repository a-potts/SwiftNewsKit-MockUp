//
//  WebBrowserViewController.swift
//  SwiftNewsKit-Design1
//
//  Created by Alex on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserViewController: UIViewController {

    // MARK: - Properties
    
    var receivedLink: URL?
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupBackButton()
        
        // Open Website
        if let receivedLink = receivedLink {
            openWebsite(url: receivedLink)
        }
    }
    
    // MARK: - Operations
    
    private func openWebsite(url: URL){
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // We grab the page title to display in the navigation header
            self.webView.evaluateJavaScript("document.title") { result, error in
                DispatchQueue.main.async {
                    if let result = result as? String {
                        self.navigationItem.title = result
                    }
                }
            }
        }
    }
    
    private func scrapeTitles(){
        webView.evaluateJavaScript(<#T##javaScriptString: String##String#>) { (result, error) in
            // code below
        }
        
    }

    // MARK: - UI
    
    private func setupBackButton(){
//        navigationController?.navigationBar.tintColor = colorli
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor =
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            //appearance.setBackIndicatorImage(UIImage(named: "x_icon"), transitionMaskImage: UIImage(named: "x_icon"))
            
            navigationItem.standardAppearance = appearance
        } else {
            // Fallback on earlier versions
            //navigationItem.leftBarButtonItem?.image = UIImage(named: "x_icon")
            
            navigationController?.navigationBar.backIndicatorImage = UIImage()
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        }
    }
}

