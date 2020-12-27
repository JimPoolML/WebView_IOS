//
//  FavoritePagesControllerViewController.swift
//  CustomWebView
//
//  Created by Jim Pool Moreno on 26/12/20.
//  Copyright © 2020 Jim Pool Moreno. All rights reserved.
//

import UIKit

class FavoritePagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Out
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private
    private var items : [String] = []
    private var indexPage : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.navigationBar.isHidden = false
        
        //Delegate
        tableView.delegate = self
        tableView.dataSource = self 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewDidAppear")
        setTableView()
    }
    
    func setTableView(){
        let simpleItems = UserDefaults.standard.object(forKey: "addItem")
        //Safe casting
        if let auxItem = simpleItems as? [String]{
            items = auxItem
        }
        //Refresh data
        tableView.reloadData()
    }
    
    // MARK: - SendFavorite List
    @IBAction func myUnwindFunction(unwindSegue: UIStoryboardSegue){
        print("Lorem ipsum")
    }
    
    func send2ndData(segue: UIStoryboardSegue){
        let auxData : String = items[indexPage]
        if (auxData.isEmpty) {
            
        }else{
            //To send data
            //Casting
            let vc = segue.destination as! ViewController
            vc.sendPage = auxData
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.dogNames.count
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPage = indexPath.row
        print("you tapped me! \(indexPath.row)")
        saveFavoritePage()
    }
    
    func saveFavoritePage(){
        let auxData : String = items[indexPage]
               if (auxData.isEmpty) {
                   print("doesn't add empty values")
               }else{
                //save data in shared preferences
                UserDefaults.standard.set(1, forKey: "pageTrue")
                UserDefaults.standard.set(auxData, forKey: "realFavoritePage")
                // Swift
                self.navigationController?.popViewController(animated: true)
               }
        
    }
    
}

