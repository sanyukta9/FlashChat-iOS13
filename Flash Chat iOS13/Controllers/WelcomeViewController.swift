//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
        //@IBOutlet weak var titleLabel: UILabel
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //using third party libraries cocoapods - CLTypingLabel module
        titleLabel.text = Constants.appName
        
        
            //       let basket = ["A","B","C"]
            //        for item in basket{
            //            print(item)
            //        }
        
            //        let titleText = "⚡️FlashChat"
            //        for letter in titleText{
            //            print(letter)
            //        }
        
        /*
         //whatever the label is now replaced with an empty string to perfrom the animation
         titleLabel.text = ""
         
         //        let titleText = "⚡️FlashChat"
         //        for letter in titleText{
         //            titleLabel.text?.append(letter)
         //        }
         //        print(titleLabel.text)
         
         let titleText = "⚡️FlashChat"
         var letterIndex = 0.0
         
         for letter in titleText{
         Timer.scheduledTimer(withTimeInterval: 0.1 * letterIndex, repeats: false) { (timer) in
         //Always wrap UI updates inside DispatchQueue.main.async if you’re not sure which thread you’re on. run when possible.
         DispatchQueue.main.async {
         self.titleLabel.text?.append(letter)
         }
         }
         letterIndex += 1
         }
         */
    }
    
    
}
