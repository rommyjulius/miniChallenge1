//
//  OnboardingPushNotifVC.swift
//  MC1
//
//  Created by Rommy Julius Dwidharma on 03/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit

class OnboardingPushNotifVC: UIViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        // Do any additional setup after loading the view.
    }
    
    func layoutUI() {
       
        
        yesButton.layer.borderWidth = 2
        yesButton.layer.borderColor = UIColor.systemGray.cgColor
        yesButton.layer.cornerRadius = 15
        
        noButton.layer.borderWidth = 2
        noButton.layer.borderColor = UIColor.systemGray.cgColor
        noButton.layer.cornerRadius = 15
    }
    
    @IBAction func yesButton(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    
    @IBAction func noButton(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
