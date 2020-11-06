//
//  CalendarDailyVC.swift
//  MC1
//
//  Created by Rommy Julius Dwidharma on 07/04/20.
//  Copyright © 2020 Rommy Julius Dwidharma. All rights reserved.
//

import UIKit
import CoreData

class CalendarDailyVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var calendarCV: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var entryTableView: UITableView!
    
    var diaries = [DiaryModel]()
    var calendarCurrIndex = 0
    var selectedCalendarIndex = 0
    var currIndex = 0
    
    let myDate = Date()
    let calendar = Calendar.current
    
    var storyDetailVC = StoryDetailVC()
    
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let dayOfMonth = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var dayInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var leapYearCounter = (year%4)
    var dayCounter = 0
    var indexcheck: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var today = Date()
        var temp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.string(from: today)
        temp = dateFormatter.date(from: "10-04-2020")!
        
        if leapYearCounter == 0
        {
            dayInMonths[1] = 29
        }
            else{
                dayInMonths[1] = 28
            }
                currentMonth = months[month]
                monthLabel.text = "\(currentMonth) \(year)"
                    if weekday == 0{
                         weekday = 7
                     }
        getStartDateDayPosition()
           
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
        
    }
    
                
       func getStartDateDayPosition(){
        switch direction {
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0{
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0{
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7{
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + dayInMonths[month])%7
            positionIndex = nextNumberOfEmptyBox
      
        case -1:
            previousNumberOfEmptyBox = (7 - (dayInMonths[month] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7{
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
            print(positionIndex)
            
        default:
            fatalError()
        }
    }


    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            
            delete(diaries[indexPath.row].title)
            self.diaries.remove(at: indexPath.row)
            // harusnya update coredate based on new array after it being removed
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            self.currIndex = indexPath.row
            let cell = (tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath)as? DiaryCell)!
            cell.titleLabel.text = diaries[indexPath.row].title
            cell.hourLabel.text = formatter.string(from: diaries[indexPath.row].date)
            cell.feelingLabel.text = diaries[indexPath.row].feeling
            
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyDetailVC = StoryDetailVC()
        performSegue(withIdentifier: "moveToStoryDetail", sender: diaries)
        self.currIndex = indexPath.row
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let storyDetailVC = segue.destination as? StoryDetailVC {
            storyDetailVC.d = diaries[currIndex]
        }
        
        //        if let svc = segue.destination as? SecondViewController {
//            svc.b = question[currIndex]
//            svc.currentIndex = currIndex
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return dayInMonths[month] + numberOfEmptyBox
        case 1:
            return dayInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return dayInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as! CalendarCVCell
        if cell.isHidden{
            cell.isHidden = false
        }
        
        var dat : Int = 0
        
        switch direction {
        case 0:
            dat = indexPath.row + 1 - numberOfEmptyBox
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            dat = indexPath.row + 1 - nextNumberOfEmptyBox
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            dat = indexPath.row + 1 - previousNumberOfEmptyBox
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        if Int(cell.dateLabel.text!)! < 1{
            cell.isHidden = true
        }
        
        let currdays = globalCalendar.component(.day, from: date)
                let cumonth = globalCalendar.component(.month, from: date)
                let cuyear = globalCalendar.component(.year, from: date)
                
                if dat == currdays && year == cuyear && month == cumonth-1{
                    //print("currentDay is", indexPath.row)
                        cell.isSelected = true
                        cell.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        cell.layer.cornerRadius = 20
                        print("current days \(currdays)")
                        print("index path\(indexPath.row)")
                    self.calendarCurrIndex = indexPath.row
                    print(calendarCurrIndex)
                }
                else
                {
                    cell.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.layer.cornerRadius = 20
                }
                
                if indexcheck == indexPath
                {
                    cell.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.layer.cornerRadius = 20
                           
                }
               
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = calendarCV.cellForItem(at: indexPath)
        self.selectedCalendarIndex = indexPath.row
        if selectedCalendarIndex != calendarCurrIndex {
            cell!.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            entryTableView.isHidden = true
            print(calendarCurrIndex)
        } else {
            cell!.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            entryTableView.isHidden = false
            print(selectedCalendarIndex)
        }
        
//        if let selectedDate = getDate(selectedDate: diaries[indexPath.row].date) {
//            fetchDataBasedOnDate(date: selectedDate)
//        }
    }
    
    func getDate(selectedDate: Date) -> String? {
        // then convert date to string again
        let dateFormatterResult = DateFormatter()
        //dateFormatterResult.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatterResult.locale = NSLocale.current
        dateFormatterResult.dateFormat = "dd-MM-yyyy hh:mm a" // 09/04/2020
        let stringDate = dateFormatterResult.string(from: selectedDate)
        return stringDate
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.layer.cornerRadius = 25
        cell?.backgroundColor = UIColor.clear
        cell?.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    func fetchDataBasedOnDate(date: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
        let fromPredicate = NSPredicate(format: "date = %@", date)
        fetchRequest.predicate = fromPredicate
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
    }
    func delete(_ title: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
        try managedContext.save()
        } catch {
            print("Failed to delete")
        }
    }
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
//    fetchRequest.returnsObjectsAsFaults = false
//    let result = try! context.fetch(fetchRequest)
//    for data in result as! [NSManagedObject] {
//        diaries.append( DiaryModel (
//            title: data.value(forKey: "title") as! String,
//            date: data.value(forKey: "date") as! Date,
//            feeling: data.value(forKey: "feelings") as! String,
//            reason: data.value(forKey: "reasons") as! String,
//            story: data.value(forKey: "story") as! String,
//            feelingAfter: data.value(forKey: "feelingAfterWriting") as! String) )
//    }


    @IBAction func nextBtn(_ sender: Any) {
        switch currentMonth {
        case "December":
            direction = 1
            month = 0
            year += 1
            
            if leapYearCounter == 3
            {
                leapYearCounter -= 3
            }
            else if leapYearCounter >= 0
            {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 0
            {
                dayInMonths[1] = 29
            }
            else if leapYearCounter >= 1
            {
                dayInMonths[1] = 28
            }

            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
            
            
            
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCV.reloadData()
        }
    }
    @IBAction func prevBtn(_ sender: Any) {
        switch currentMonth {
               case "January":
                   direction = -1
                   month = 11
                   year -= 1
                   
                   //untuk cek leap year
                   if leapYearCounter == 0
                   {
                       leapYearCounter += 3
                   }
                   else if leapYearCounter >= 1
                   {
                       leapYearCounter -= 1
                   }
                   // untuk ganti hari tanggal feb per tahun
                   if leapYearCounter == 0
                   {
                       dayInMonths[1] = 29
                   }
                   else if leapYearCounter >= 1
                   {
                       dayInMonths[1] = 28
                   }
                   
                   getStartDateDayPosition()
                   
                   currentMonth = months[month]
                   monthLabel.text = "\(currentMonth) \(year)"
                   calendarCV.reloadData()
               default:
                   direction = -1
                   
                   month -= 1
                   
                   
                   
                   getStartDateDayPosition()
                   
                   currentMonth = months[month]
                   monthLabel.text = "\(currentMonth) \(year)"
                   calendarCV.reloadData()
               }
    }
    @IBAction func backBtn(_ sender: Any) {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)

    }

   
         func CheckcollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    let cell = calendarCV.cellForItem(at: indexPath)

                    print(calendarCurrIndex)
                    if indexcheck == indexPath
                    {
                        indexcheck = nil
                        cell!.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        cell?.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
                    }
                    else if indexcheck == nil
                    {
                        indexcheck = indexPath
                        cell!.layer.backgroundColor = #colorLiteral(red: 0.5947638154, green: 0.7021438479, blue: 0.9868053794, alpha: 1)
                        cell?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    else
                    {
                        indexcheck = indexPath
                        cell!.layer.backgroundColor = #colorLiteral(red: 0.5947638154, green: 0.7021438479, blue: 0.9868053794, alpha: 1)
                        cell?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
                    }
                    print("tanggal \(day),bulan \(month + 1), tahun \(year)")
                    collectionView.reloadData()
                }
              
            func checkcollectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
                  let cell = calendarCV.cellForItem(at: indexPath)
                  print("deselect")
                    cell!.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell?.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                  
              }
    }


    



