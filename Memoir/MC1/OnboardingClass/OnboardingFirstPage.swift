//
//  StoryVC.swift
//  MC1
//
//  Created by Dimas Pagam on 03/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit



class OnboardingFirstPage: UIViewController
{
//button
    
//
    override func viewDidLoad()
    {
        super.viewDidLoad()

      
    }

    @IBAction func nextBtn(_ sender: Any) {
        performSegue(withIdentifier: "moveToNextOnboard", sender: self)
    }
    
}
