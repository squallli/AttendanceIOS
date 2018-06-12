//
//  UIViewControlAttenadanceViewController.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/25.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit
import CVCalendar

class UIViewControlAttenadanceViewController: UIViewController ,CVCalendarViewDelegate,CVCalendarMenuViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var Attcanlendar: CVCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var attendanceData : CardData?
    var selectDay:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        monthLabel.text = CVDate(date: Foundation.Date()).globalDescription
        
        let SDate = GetDateWithFormat(Foundation.Date(),format: "yyyyMM01")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
       
        let EDate = dateFormatter.string(from: Foundation.Date())
        
        
        selectDay = GetDateWithFormat(Foundation.Date(),format:"yyyy-MM-dd")
        
        let rest = clsRestful()
        rest.getJsonData("\(Global.apiUrl)Attendance?EmpNo=\(Global.UserId!)&SDATE=\(SDate)&EDATE=\(EDate)",onSuccess: {result -> Void in
            
            self.refreshCalendar(result)
            
            DispatchQueue.main.async(execute: {
                
                self.tableView.reloadData()
            })
            
            },onError: {err -> Void in
                DispatchQueue.main.async(execute: {
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
        })
        
    }
    
    func didShowNextMonthView(_ date: Foundation.Date)
    {
        let SDate = GetDateWithFormat(date.addingTimeInterval(60*60*24),format: "yyyyMM") + "01"
        let EDate = getLastDayOfMonth(date.addingTimeInterval(60*60*24))
        
        selectDay = SDate
        
        let rest = clsRestful()
        rest.getJsonData("\(Global.apiUrl)Attendance?EmpNo=\(Global.UserId!)&SDATE=\(SDate)&EDATE=\(EDate)",onSuccess: {result -> Void in

            
            self.refreshCalendar(result)
            
            DispatchQueue.main.async(execute: {
                
                self.tableView.reloadData()
            })
            
            },onError:{err -> Void in
                DispatchQueue.main.async(execute: {
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
        })
        
    }
    
    func didShowPreviousMonthView(_ date: Foundation.Date){
        let SDate = GetDateWithFormat(date,format: "yyyyMM") + "01"
        let EDate = getLastDayOfMonth(date.addingTimeInterval(60*60*24))
        
        selectDay = SDate
        
        let rest = clsRestful()
        
        rest.getJsonData("\(Global.apiUrl)Attendance?EmpNo=\(Global.UserId!)&SDATE=\(SDate)&EDATE=\(EDate)",onSuccess: {result -> Void in
            
            self.refreshCalendar(result)
            
            
            
            },onError:{err -> Void in
                
                DispatchQueue.main.async(execute: {
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
                
        })
        
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
                }) { _ in
                    
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransform.identity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }


    func getLastDayOfMonth(_ date:Foundation.Date) -> String{
        

        var newDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: date)
        newDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: newDate!)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: (newDate?.addingTimeInterval(-60*60*24))!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        menuView.commitMenuViewUpdate()
        self.Attcanlendar.commitCalendarViewUpdate()

        self.menuView.commitMenuViewUpdate()
    }
    
    func presentationMode() -> CalendarMode{
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday{
        return .sunday
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func GetDateWithFormat(_ d:Foundation.Date,format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let s = dateFormatter.string(from: d)
        
        return s
    }
    
    func refreshCalendar(_ result:Any){
         attendanceData = CardData(json: result as! [[String : Any]])
        DispatchQueue.main.async(execute: {
        
            self.tableView.reloadData()
            self.Attcanlendar.contentController.refreshPresentedMonth()
        })
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool)
    {
        
        if let finalDate = dayView.date {
            let month = String(format: "%02d", finalDate.month)
            let day = String(format: "%02d", finalDate.day)
            
            selectDay = "\(finalDate.year)-\(month)-\(day)"
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        }
        
    }

}

extension UIViewControlAttenadanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        
        guard  let attendanceData = attendanceData else {
            return 0
        }
        
        if( attendanceData.Contains(date: selectDay!))
        {
            return 1
        }
        else
        {
            return 0
        }
        
    }
    
    //填充UITableViewCell中文字標簽的值
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceCell
        
        cell.clearData()
        cell.setCardType("1", cardTime: "")
        cell.setCardType("2", cardTime: "")
        cell.setCardType("3", cardTime: "")
        cell.setCardType("4", cardTime: "")
        
        
        if let attData:CardTimeList = attendanceData?.getCardData(date: selectDay!)
        {
            cell.setEmployeeName(attData.EmployeeName)
            
            for object in attData.cardTimelist {
                cell.setCardType(object.CardType, cardTime: object.CardTime)
            }
            
        }

        return cell
    }
}

