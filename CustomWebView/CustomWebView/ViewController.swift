//
//  ViewController.swift
//  CustomWebView
//
//  Created by Jim Pool Moreno on 12/15/20.
//  Copyright © 2020 Jim Pool Moreno. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    // MARK: - Out
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnForward: UIBarButtonItem!
    @IBOutlet weak var btnReload: UIBarButtonItem!
    @IBOutlet weak var btnHome: UIBarButtonItem!
    // MARK: - Private
    private let searchBar = UISearchBar()
    //Global component
    private var webView = WKWebView()
    //Refresh
    private let reloadPage = UIRefreshControl()
    //URL-HOME
    private let baseURL = "http://www.google.com"
    private let assingPath = "/search?q="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Buttons to navigate®
        btnBack.isEnabled = false
        btnForward.isEnabled = false
        
        //Instance search bar
        self.navigationItem.titleView = searchBar
        
        //Use delegate
        searchBar.delegate = self
        
        //WebView - instance
        //Navigation preferences
        let webViewPrefs = WKPreferences()
        //Support javaScript
        webViewPrefs.javaScriptEnabled = true
        //Multiple windows in the explorer
        webViewPrefs.javaScriptCanOpenWindowsAutomatically = true
        //
       // webViewPrefs.
        //Configuration Object
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.preferences = webViewPrefs
        //Assing values
        webView = WKWebView(frame: view.frame, configuration: webViewConfig)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //HideKeyboard when the scroll is activate
        webView.scrollView.keyboardDismissMode = .onDrag
        
        view.addSubview(webView)
        //Delegate webView (casting)
        webView.navigationDelegate = (self as WKNavigationDelegate)
        
        //Reload
        // #selector is used to use any method in the class
        reloadPage.addTarget(self, action: #selector(rechargePage), for: .valueChanged)
        webView.scrollView.addSubview(reloadPage)
        view.addSubview(reloadPage)
        
        loadURL(url: baseURL)
    }

    //MARK: - Another Methods
    private func loadURL(url : String){
        var saveURL: URL!
        if let url  = URL(string: url),
            UIApplication.shared.canOpenURL(url){
            saveURL = url
        }else{
            //Concat secure text
            saveURL = URL(string: "\(baseURL)\(assingPath)\(url)")!
        }
        webView.load(URLRequest(url:  saveURL))
    }
    
    //To use in #selector
    @objc private func rechargePage(){
        webView.reload()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        webView.goBack()
    }
    
    
    @IBAction func btnForwardAction(_ sender: Any) {
        webView.goForward()
    }
    
    
    @IBAction func btnReloadPage(_ sender: Any) {
        print("button is reloaded")
        if webView.url != nil {
            webView.reload()
        } else {
            loadURL(url: searchBar.text ?? "")
            //webView.load(URLRequest(url: originalURL))
        }
        
        //searchBar.endEditing(true)
        //Set URL in webView
        //loadURL(url: searchBar.text ?? "")
        
        //webView.reload()
    }
    
    @IBAction func btnHomeAction(_ sender: Any) {
        //Go home in webView
        print("button is pressed")
        loadURL(url: baseURL )
    }
}

// MARK: - UISearchDelegate

//Delegate class extensión
extension ViewController : UISearchBarDelegate{
    
    //Click to search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        //Set URL in webView
        loadURL(url: searchBar.text ?? "")
    }
}

//Delegate WebView
extension ViewController: WKNavigationDelegate{
    //Finish to load the webView
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //Finish the load page
        reloadPage.endRefreshing()
        //Enable backButton
        btnBack.isEnabled = webView.canGoBack
        //Enable forwardButton
        btnForward.isEnabled = webView.canGoForward
    }
    
    //Start to load the page
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //Start the load page
        reloadPage.beginRefreshing()
        
        //Assing URL in into searchBar
        searchBar.text = webView.url?.absoluteString
        
        //Enable home
        btnReload.isEnabled = webView.isLoading
    }
}
