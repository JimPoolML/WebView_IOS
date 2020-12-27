//
//  FavoritePagesControllerViewController.swift
//  CustomWebView
//
//  Created by Jim Pool Moreno on 26/12/20.
//  Copyright © 2020 Jim Pool Moreno. All rights reserved.
//

import UIKit

class FavoritePagesControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Lorem ipsum")
//        if self.passedData != nil{
//            print(passedData!)
//            userText.text =  passedData
//        }
    }
    
    // MARK: - SendFavorite List
    @IBAction func myUnwindFunction(unwindSegue: UIStoryboardSegue){
        print("Lorem ipsum")
//            if self.passedData != nil{
//                print(passedData!)
//            }
    }

}
