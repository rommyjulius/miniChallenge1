//
//  Onboarding.swift
//  MC1
//
//  Created by Rommy Julius Dwidharma on 03/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit

class OnboardingInputNameVC: UIViewController, UITextViewDelegate {

  
    @IBOutlet weak var nameTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    override func viewWillDisappear(_ animated: Bool) {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
          }

    @objc func keyboardWillHide(notification: NSNotification) {
       //        self.view.frame.origin.y += 280
               if self.view.frame.origin.y != 0 {
                   self.view.frame.origin.y = 0
               }
           }

    @objc func keyboardWillShow(notification: NSNotification) {
       //        self.view.frame.origin.y -= 280
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y == 0 {
                       self.view.frame.origin.y -= keyboardSize.height
                   }
               }
           }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if nameTextField.text == "Type your name here ..." {
            nameTextField.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if nameTextField == nil {
            nameTextField.text = ""
            nameTextField.text = "Type your name here ..."
        }
    }
    @IBAction func nextButton(_ sender: Any) {
        UserDefaults.standard.set(nameTextField.text!, forKey: "userName")
        self.performSegue(withIdentifier: "pushNotification", sender: self)
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
