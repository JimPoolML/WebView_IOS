//
//  ViewController.swift
//  CustomWebView
//
//  Created by Jim Pool Moreno on 12/15/20.
//  Copyright © 2020 Jim Pool Moreno. All rights reserved.
//

import UIKit
import WebKit
import AudioToolbox

class ViewController: UIViewController {

    // MARK: - Out
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnForward: UIBarButtonItem!
    @IBOutlet weak var btnReload: UIBarButtonItem!
    @IBOutlet weak var btnHome: UIBarButtonItem!
    // MARK: - Private
    private let searchBar = UISearchBar()
    
    // MARK: Global component
    private var webView = WKWebView()
    //Refresh
    private let reloadPage = UIRefreshControl()
    //URL-HOME
    var favoritePage : String = ""
    private let baseURL = "https://www.google.com"
    private let assingPath = "/search?q="
    var sendPage : String = ""
    var isTruePage : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Buttons to navigate®
        btnBack.isEnabled = false
        btnForward.isEnabled = false
        
        //Instance search bar
        self.navigationItem.titleView = searchBar
        
        //Use delegate
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "btn_star"), for: .bookmark, state: .normal)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewDidAppear First Controller")
        //load data in shared preferences
        isTruePage = UserDefaults.standard.object(forKey: "pageTrue") as! Int
        print(isTruePage)
        if(isTruePage == 1){
            let realFavoritePage = UserDefaults.standard.object(forKey: "realFavoritePage")
            //Avoid reload a favorite page
            isTruePage = 0
            UserDefaults.standard.set(isTruePage, forKey: "pageTrue")
            loadURL(url: realFavoritePage as! String)
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.loadURL(url: self.searchBar.text ?? "")
            } else {
                self.loadURL(url: self.searchBar.text ?? "")
            }
        })
    }
    
    //MARK: - Send page data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if segue.identifier == "sendFavDataSegue"{
            print("sendFavDataSegue is called")
        }
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
    
    private func addFavoriteItems(favPage : String){
        //doesn't add empty values
        let favPage = favPage.trimmingCharacters(in: .whitespacesAndNewlines)
        if (favPage == ""){
            //setAlert()
            print("doesn't add empty values")
            return
        }
        
        let simpleItems = UserDefaults.standard.object(forKey: "addItem")
            var items : [String]
            
            //Safe casting
            if let auxItem = simpleItems as? [String]{
                items = auxItem
                items.append(favPage)
            }else{
                items = [favPage]
            }
        
            print(items)
            //save data in shared preferences
            UserDefaults.standard.set(items, forKey: "addItem")
    }
    
    
    
    private func alertDialogPage(){
        let alertControl = UIAlertController(title: "Mis Favoritos", message: "Agregar a favoritos", preferredStyle: .alert)
        
        alertControl.addTextField(configurationHandler: {
            (_ textField : UITextField ) -> Void in
            textField.placeholder = "Nombre"
            textField.textAlignment = .center
            textField.textColor = UIColor.blue
            textField.keyboardType = UIKeyboardType.alphabet
        })
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let saveAction = UIAlertAction(title: "Rename", style: .default)
            { _ in
                self.favoritePage = alertControl.textFields?[0].text ?? ""
                
                if(self.favoritePage.isEmpty)
                {
                    print ("Faltan campos por llenar")
                    self.toastMessage(msg: "Faltan campos por llenar")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                else{
                    self.addFavoriteItems(favPage : self.searchBar.text ?? "")
                    print("Favorite Page: \(String(describing: self.favoritePage)) ")
                }
            }
            
            alertControl.addAction(actionCancel)
            alertControl.addAction(saveAction)
            
            self.present(alertControl, animated: true, completion: nil)
    }
    
    func toastMessage(msg: String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
           alert.view.backgroundColor = UIColor.black
           alert.view.alpha = 0.6
           alert.view.layer.cornerRadius = 15

           present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
               alert.dismiss(animated: true)
           }
    }
    
    
    
    //To use in #selector
    @objc private func rechargePage(){
        webView.reload()
    }
    
    //MARK: - WebView buttons
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
        }
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
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        alertDialogPage()
        print("click")
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
