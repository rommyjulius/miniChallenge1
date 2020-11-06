//
//  StoryDetailVC.swift
//  MC1
//
//  Created by Rommy Julius Dwidharma on 08/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit
import CoreData

class StoryDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var feelingPicker: UIPickerView!
    @IBOutlet weak var reasonPicker: UIPickerView!
    @IBOutlet weak var afterWriteFeelingPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var feelingInitiate: UIButton!
    @IBOutlet weak var reasonInitiate: UIButton!
    @IBOutlet weak var afterWritingInitiate: UIButton!
    
    var feelingArr = ["😃 Happy", "🥳 Blessed","🙂 Fine","😭 Sad","😡 Angry","🤢 Sick","🤯 Stressed","😰 Anxious"]
    var reasonArr = ["Family","Friends","Spouse","Colleague","Pet","Work","School","Other"]
    var feelingAfterWriteArr = ["Better","The Same","Worse"]
    
    var feelingTemp = ""
    var reasonTemp = ""
    var afterWritingTemp = ""
    var titleTemp = ""
    var emptyDate: Date? = nil
    var d = DiaryModel(title: "", date: Date(), feeling: "", reason: "", story: "", feelingAfter: "")
    var diaries = [DiaryModel] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        receive(diary: d)
    }
    func receive(diary: DiaryModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        titleTextView?.text = diary.title as String
        dateLabel?.text = dateFormatter.string(from: diary.date)
        feelingInitiate?.setTitle(diary.feeling, for: .normal)
        reasonInitiate?.setTitle(diary.reason, for: .normal)
        storyTextView?.text = diary.story
        afterWritingInitiate?.setTitle(diary.feelingAfter, for: .normal)
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case feelingPicker:
            return feelingArr[row]
        case reasonPicker:
            return reasonArr[row]
        case afterWriteFeelingPicker:
            return feelingAfterWriteArr[row]
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        switch pickerView {
        case feelingPicker:
            attributedString = NSAttributedString(string: feelingArr[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        case reasonPicker: attributedString = NSAttributedString(string: reasonArr[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        case afterWriteFeelingPicker:
            attributedString = NSAttributedString(string: feelingAfterWriteArr[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        default:
            attributedString = nil
        }
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == feelingPicker {
            return feelingArr.count
        }else if pickerView == reasonPicker {
            return reasonArr.count
        }else{
            return feelingAfterWriteArr.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == feelingPicker{
            self.feelingInitiate.setTitle(feelingArr[row], for: .normal)
            feelingPicker.isHidden = true
            feelingTemp = feelingArr[row] as String
        }else if pickerView == reasonPicker{
            self.reasonInitiate.setTitle(reasonArr[row], for: .normal)
            reasonPicker.isHidden = true
            reasonTemp = reasonArr[row] as String
        }else{
            self.afterWritingInitiate.setTitle(feelingAfterWriteArr[row], for: .normal)
            afterWriteFeelingPicker.isHidden = true
            afterWritingTemp = feelingAfterWriteArr[row] as String
        }
    }
    
    func update(_ title: String, _ feelings: String, _ reasons: String, _ story: String,  _ feelingAfterWriting: String ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(titleTextView.text, forKey: "title")
            dataToUpdate.setValue(feelingTemp, forKey: "feelings")
            dataToUpdate.setValue(reasonTemp, forKey: "reasons")
            dataToUpdate.setValue(storyTextView.text, forKey: "story")
            dataToUpdate.setValue(afterWritingTemp, forKey: "feelingAfterWriting")
            
            try managedContext.save()
        }catch let err{
            print(err)
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
    
    @IBAction func chooseFeelingBtn(_ sender: Any) {
        feelingPicker.isHidden = false
    }
    @IBAction func chooseReasonBtn(_ sender: Any) {
        reasonPicker.isHidden = false
    }
    @IBAction func chooseAfterWritingBtn(_ sender: Any) {
        afterWriteFeelingPicker.isHidden = false
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: Any) {
        update(d.title, d.feeling, d.reason, d.story, d.feelingAfter)
        let calendarDailyVC = storyboard?.instantiateViewController(withIdentifier: "calendarDailyVC") as! CalendarDailyVC
        calendarDailyVC.modalPresentationStyle = .fullScreen
        present(calendarDailyVC, animated: true)
    }


    

}
