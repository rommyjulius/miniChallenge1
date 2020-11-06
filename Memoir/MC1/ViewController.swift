//
//  ViewController.swift
//  MC1
//
//  Created by Rommy Julius Dwidharma on 03/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var dailyViewCV: UICollectionView!
    @IBOutlet weak var monthlyViewCV: UICollectionView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currDateLabel: UILabel!
    @IBOutlet weak var dailyViewCount: UILabel!
    @IBOutlet weak var monthlyViewCount: UILabel!
    
    var feelingArr = ["😃 Happy", "🥳 Blessed","🙂 Fine","😭 Sad","😡 Angry","🤢 Sick","🤯 Stressed","😰 Anxious"]
    var reasonArr = ["Family","Friends","Spouse","Colleague","Pet","Work","School","Other"]
    var feelingAfterWriteArr = ["Better","The Same","Worse"]
    var diaries = [DiaryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
               //        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
            let result = try! managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                diaries.append( DiaryModel (
                    title: data.value(forKey: "title") as! String,
                    date: data.value(forKey: "date") as! Date,
                    feeling: data.value(forKey: "feelings") as! String,
                    reason: data.value(forKey: "reasons") as! String,
                    story: data.value(forKey: "story") as! String,
                    feelingAfter: data.value(forKey: "feelingAfterWriting") as! String) )
                
                }
        loadData()
        
        dailyViewCount.text = "\(diaries.count)"
        monthlyViewCount.text = "\(diaries.count)"
        
        self.dailyViewCV.backgroundColor = UIColor.clear
        self.monthlyViewCV.backgroundColor = UIColor.clear
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UserDefaults.standard.string(forKey: "userName") == nil{
            let onboarding = storyboard?.instantiateViewController(withIdentifier: "onboardingFirstPage") as! OnboardingFirstPage
            onboarding.modalPresentationStyle = .fullScreen
            present(onboarding, animated: true)
        }
    }
    func loadData() {
         userNameLabel.text = UserDefaults.standard.string(forKey: "userName")
        
        let now = Date()
        let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "dd/MMMM/ YYYY"
        let dateString = formatter.string(from: now)
        currDateLabel.text = dateString
    }
    @IBAction func addNewBtn(_ sender: Any) {
        performSegue(withIdentifier: "addNewStory", sender: self)
    }

    @IBAction func dailyCalendarViewBtn(_ sender: Any) {
        performSegue(withIdentifier: "seeDailyCalendarView", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyViewCV {
            return diaries.count
        }else{
            return diaries.count
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dailyViewCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyViewCV", for: indexPath) as! DailyViewCVC
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.feelingLabel.text = diaries[indexPath.row].feeling
            cell.feelingCount.text = "\(1)"
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyViewCV", for: indexPath) as! MonthlyViewCVC
            cell.feelingLabel.text = diaries[indexPath.row].feeling
            cell.countLabel.text = "\(1)"
            return cell
        }
    }
    

}

