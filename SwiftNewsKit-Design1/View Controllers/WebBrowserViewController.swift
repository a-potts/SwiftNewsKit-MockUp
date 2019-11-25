//
//  WebBrowserViewController.swift
//  SwiftNewsKit-Design1
//
//  Created by Alex on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup

class WebBrowserViewController: UIViewController {

    // MARK: - Properties
    
    var receivedLink: URL?
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupBackButton()
        webView.navigationDelegate = self

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
                        self.scrapeUrls(url: url)
                    }
                }
            }
        }
    }
    
    private func scrapeUrls(url: URL){
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            let links: Elements = try doc.select("a[href]") // a with href

            for link in links {
                // We want to narrow this down to only display links within <div class="clus"> *WE WANT THE HREF HERE* <div>
                print("HERE LINK: ", link)
            }
        } catch {
            // contents could not be loaded
            print("Error loading page contents")
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

extension WebBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(webView.url)")

//        webView.evaluateJavaScript("myFunction()") { (any, error) in
//            dump(error)
//            print(any)
//        }
        
//        let js = """
//var url = document.querySelector('.free-section a').href;
//console.log(url);
//"""
//
//        """
//        var url = document.querySelector('.ii a').href;
//        alert(url);
//        """
        
//        let js = """
//var url_finder = class => {
//        return document.querySelector(class).href }
//"""
        
//        let js = "document.querySelector('.clus a').href;"
//        let js = """
//        var url = document.querySelector('.ii a').href;
//        alert(url);
//        """
        //"document.getElementsByTagName('html')[0].innerHTML"  document.getElementsById('html')[0].innerHTML

        
        // Pull every link on website
        let js = """
var arr = [], l = document.links;
for(var i=0; i<l.length; i++) {
  arr.push(l[i].href);
}
arr
"""
        // This works UNCOMMENT to test javascript. Displays all links on page.
        webView.evaluateJavaScript(js) { (result, error) in
            if let error = error {return print("HERE Error evaluating javascript: ", error)}
            //print("HERE Javascript result: ", result)
        }
    }
}
