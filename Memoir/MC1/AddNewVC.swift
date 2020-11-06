//
//  AddNewVC.swift
//  MC1
//
//  Created by Aira S Araffanda on 05/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit
import CoreData

class AddNewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
//iboutlet
    @IBOutlet weak var feelingCV: UICollectionView!
    @IBOutlet weak var reasonCV: UICollectionView!
    @IBOutlet weak var feelingAfterCV: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextField: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
//var array, index, date
    var feelingArr = ["😃 Happy", "🥳 Blessed","🙂 Fine","😭 Sad","😡 Angry","🤢 Sick","🤯 Stressed","😰 Anxious"]
    var reasonArr = ["Family","Friends","Spouse","Colleague","Pet","Work","School","Other"]
    var feelingAfterWriteArr = ["Better","The Same","Worse"]
    var feelingCurrIndex = 0
    var reasonCurrIndex = 0
    var feelingAfterCurrIndex = 0
    var date = Date()
    let formatter = DateFormatter()
    
    var calendarDailyVC = CalendarDailyVC()

//var managed object context
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTextField.delegate = self
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
        textViewSetting()
        getTodaysDate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    func getTodaysDate(){
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateLabel.text = "\(formatter.string(from: date))"
    }
    
    func textViewSetting() {
        storyTextField.layer.cornerRadius = 15
        feelingCV.allowsMultipleSelection = false
        feelingCV.allowsSelection = true
        
        storyTextField.text = "Tell your story ..."
        storyTextField.textColor = UIColor.gray
        titleTextField.text = "Title"
        titleTextField.textColor = UIColor.gray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == storyTextField {
            if storyTextField.text == "Tell your story ..." {
                storyTextField.textColor = UIColor.gray
                storyTextField.text = ""
                storyTextField.textColor = UIColor.black
            }
        }else{
            if titleTextField.text == "Title" {
                titleTextField.textColor = UIColor.gray
                titleTextField.text = ""
                titleTextField.textColor = UIColor.black
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == storyTextField {
            if storyTextField == nil {
                storyTextField.text = ""
                storyTextField.text = "Tell your story ..."
                storyTextField.textColor = UIColor.black
            }
        }else{
            if titleTextField == nil {
                titleTextField.text = ""
                titleTextField.text = "Title"
                titleTextField.textColor = UIColor.black
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if collectionView == feelingCV {
               return feelingArr.count
           }else if collectionView == reasonCV {
               return reasonArr.count
           }else {
               return feelingAfterWriteArr.count
           }
    }
       
    let customPurple = UIColor(red: 152/255, green: 178/255, blue: 252/255, alpha: 1.0)


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == feelingCV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feeling", for: indexPath) as! FeelingCVC
               cell.feelingLabel.text = feelingArr [indexPath.row]
               cell.contentView.layer.cornerRadius = 18
               cell.contentView.layer.borderWidth = 1
               cell.contentView.layer.borderColor = customPurple.cgColor
               return cell
           }else if collectionView == reasonCV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reason", for: indexPath) as! ReasonCVC
               cell.reasonLabel.text = reasonArr [indexPath.row]
               cell.contentView.layer.cornerRadius = 18
               cell.contentView.layer.borderWidth = 1
               cell.contentView.layer.borderColor = customPurple.cgColor
               return cell
           }else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feelingAfter", for: indexPath) as! FeelingAfterCVC
               cell.feelingAfterLabel.text = feelingAfterWriteArr [indexPath.row]
               cell.contentView.layer.cornerRadius = 18
               cell.contentView.layer.borderWidth = 1
               cell.contentView.layer.borderColor = customPurple.cgColor
               return cell
           }

    }
    
 
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == feelingCV{
            let cell = feelingCV.cellForItem(at: indexPath)
            self.feelingCurrIndex = indexPath.row
            cell?.layer.shadowColor = UIColor.gray.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 2.0
            cell?.layer.shadowOpacity = 0.5
            cell?.layer.backgroundColor = customPurple.cgColor
            cell?.layer.masksToBounds = false
            cell?.layer.cornerRadius = 18
            cell?.layer.borderWidth = 2
            cell?.layer.borderColor = customPurple.cgColor
        }else if collectionView == reasonCV{
            let cell = reasonCV.cellForItem(at: indexPath)
            self.reasonCurrIndex = indexPath.row
            cell?.layer.shadowColor = UIColor.gray.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 2.0
            cell?.layer.shadowOpacity = 0.5
            cell?.layer.backgroundColor = customPurple.cgColor
            cell?.layer.masksToBounds = false
            cell?.layer.cornerRadius = 18
            cell?.layer.borderWidth = 2
            cell?.layer.borderColor = customPurple.cgColor
        }else{
            let cell = feelingAfterCV.cellForItem(at: indexPath)
            self.feelingAfterCurrIndex = indexPath.row
            cell?.layer.shadowColor = UIColor.blue.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 2.0
            cell?.layer.shadowOpacity = 0.5
            cell?.layer.backgroundColor = customPurple.cgColor
            cell?.layer.masksToBounds = false
            cell?.layer.cornerRadius = 18
            cell?.layer.borderWidth = 2
            cell?.layer.borderColor = customPurple.cgColor
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == feelingCV{
            let cell = feelingCV.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 18
            cell?.layer.borderColor = customPurple.cgColor
            cell?.layer.borderWidth = 1
            cell?.layer.shadowColor = UIColor.clear.cgColor
            cell?.layer.backgroundColor = UIColor.clear.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 0
            cell?.layer.shadowOpacity = 0
            cell?.layer.masksToBounds = false
        }else if collectionView == reasonCV{
            let cell = reasonCV.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 18
            cell?.layer.borderColor = customPurple.cgColor
            cell?.layer.borderWidth = 1
            cell?.layer.shadowColor = UIColor.clear.cgColor
            cell?.layer.backgroundColor = UIColor.clear.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 0
            cell?.layer.shadowOpacity = 0
            cell?.layer.masksToBounds = false
        }else{
            let cell = feelingAfterCV.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 18
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 1
            cell?.layer.shadowColor = UIColor.clear.cgColor
            cell?.layer.backgroundColor = UIColor.clear.cgColor
            cell?.layer.shadowOffset = CGSize()
            cell?.layer.shadowRadius = 0
            cell?.layer.shadowOpacity = 0
            cell?.layer.masksToBounds = false
        }
    }
    func addData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let diaryEntity = NSEntityDescription.entity(forEntityName: "Diary", in: managedContext)!
        let diary = NSManagedObject(entity: diaryEntity, insertInto: managedContext)
        diary.setValue(titleTextField.text, forKeyPath: "title")
        diary.setValue(date, forKey: "date")
        diary.setValue("\(feelingArr[feelingCurrIndex])", forKey: "feelings")
        diary.setValue("\(reasonArr[reasonCurrIndex])", forKey: "reasons")
        diary.setValue(storyTextField.text, forKey: "story")
        diary.setValue("\(feelingAfterWriteArr[feelingAfterCurrIndex])", forKey: "feelingAfterWriting")
        do {
            try managedContext.save()
            print("Input ok!")
        } catch let error as NSError {
            print("Couldn't save \(error), \(error.userInfo)")
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addBtn(_ sender: Any) {
        addData()
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    

   
}
