
import UIKit
import CVCalendar

class ViewController: UIViewController ,CVCalendarViewDelegate,CVCalendarMenuViewDelegate{




    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var monthLabel: UILabel!
    
   
    @IBOutlet weak var menuView: CVCalendarMenuView!

    @IBOutlet weak var calendarView: CVCalendarView!
    


    
    
    var outGoingList:clsOutGoingList?

    var Year:String?
    var Month:String?
    var selectDay:String?

    
    @IBAction func LogoutClick(_ sender: AnyObject) {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set("", forKey: "UserName")
        prefs.set("", forKey: "Password")
        prefs.set(false, forKey: "ISLOGGEDIN")
        
        self.performSegue(withIdentifier: "backSegue", sender: self)
    }
 
    @IBAction func addSchduleClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier :"addSchedule") as! OutgoingViewController
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selectedDay = dateFormatter.date(from: selectDay!)
        
        destination.delegate = self
        destination.defaultDate = selectedDay! as NSDate
        show(destination, sender: nil)
        //self.performSegue(withIdentifier: "addSegue", sender: self)
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SDate = GetDateWithFormat(Foundation.Date(),format: "yyyyMM") + "01"
        let EDate = GetDateWithFormat(Foundation.Date(),format: "yyyyMM") + "31"
        
        selectDay = GetDateWithFormat(Foundation.Date(),format:"yyyy-MM-dd")
        
        monthLabel.text = CVDate(date: Foundation.Date()).globalDescription
        tableView.dataSource = self
        tableView.delegate = self
        
        
        dataBind(SDate: SDate,EDate: EDate)
        
    }
    
    func dataBind(SDate:String,EDate:String)
    {
        let rest = clsRestful()
        rest.getJsonData("\(Global.apiUrl)Outgoing?EmpNo=\(Global.UserId!)&SDATE=\(SDate)&EDATE=\(EDate)",onSuccess: {result -> Void in
            
            self.refreshCalendar(result)
            
        },onError: {err -> Void in
            DispatchQueue.main.async(execute: {
                let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);
                
                let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                
                quetion.addAction(okaction);
                self.present(quetion, animated: true, completion: nil);
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        
    }
    
    func GetDateWithFormat(_ d:Foundation.Date,format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
       
        let s = dateFormatter.string(from: d)
        
        return s
    }

    func presentationMode() -> CalendarMode
    {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday
    {
        return .sunday
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool)
    {
    
        guard let tableView = tableView else {
            return
        }
        
        if let finalDate = dayView.date {
            let month = String(format: "%02d", finalDate.month)
            let day = String(format: "%02d", finalDate.day)
            
            selectDay = "\(finalDate.year)-\(month)-\(day)"
            tableView.reloadData()
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
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

    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        let π = Double.pi
        
        let ringSpacing: CGFloat = 5.0
        let ringInsetWidth: CGFloat = 5.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 3.0
        let ringLineColour: UIColor = UIColor.blue
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRect(x: newView.frame.midX-radius, y: newView.frame.midY-radius-ringVerticalOffset, width: diameter, height: diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = rect.insetBy(dx: ringLineWidthInset, dy: ringLineWidthInset)
        let centrePoint: CGPoint = CGPoint(x: ringRect.midX, y: ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        
        ringLayer.frame = newView.layer.bounds
        
        newView.center = dayView.center
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let currentDay = dayView.date
        {
            let month = String(format: "%02d", currentDay.month)
            let day = String(format: "%02d", currentDay.day)
            
            let finalDate = "\(currentDay.year)-\(month)-\(day)"
            
            guard let outGoingList = outGoingList else {
                return false
            }
            
            if (outGoingList.Contains(date: finalDate)){
                return true
            }
            else{return false}
        }
        else {return false}
    
    }
    
    func refreshCalendar(_ result:Any){
        outGoingList = clsOutGoingList(json: result as! [[String : Any]])
        DispatchQueue.main.async(execute: {
            
            self.tableView.reloadData()
            self.calendarView.contentController.refreshPresentedMonth()
        })
    }
    
    func didShowNextMonthView(_ date: Foundation.Date)
    {
        let SDate = GetDateWithFormat(date.addingTimeInterval(60*60*24),format: "yyyyMM") + "01"
        let EDate = GetDateWithFormat(date.addingTimeInterval(60*60*24),format: "yyyyMM") + "31"
        
        selectDay = SDate
        
        dataBind(SDate: SDate,EDate: EDate)
 
    }
    
    func didShowPreviousMonthView(_ date: Foundation.Date){
        let SDate = GetDateWithFormat(date,format: "yyyyMM") + "01"
        let EDate = GetDateWithFormat(date,format: "yyyyMM") + "31"
        
        selectDay = SDate
        
        dataBind(SDate: SDate,EDate: EDate)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {

        guard let outGoingList = outGoingList else {
            return 0
        }
        
        return outGoingList.getOutGoingCount(date: selectDay!)
    }
    
    //填充UITableViewCell中文字標簽的值
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCellCanlendarTableViewCell
        
        if let outData = outGoingList?.getOUtGoingData(date: selectDay!)
        {
            cell.setCustomer(outData[indexPath.row].m_customer)
            cell.setDate(outData[indexPath.row].m_outDate)
            cell.setLocation(outData[indexPath.row].m_Location)
            cell.setMettingTime(mettingtime: outData[indexPath.row].m_MettingTime)
            cell.setOutTime(outTime: outData[indexPath.row].m_outTime)
        }
  
        return cell
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let outGoingList = outGoingList else {
            return false
        }
        
        let outData = outGoingList.getOUtGoingData(date: selectDay!)
        
        
        let selectedDay = dateFormatter.date(from: outData[indexPath.row].m_outDate + " " + outData[indexPath.row].m_outTime)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today = dateFormatter.date(from: getTodayString())
        
        if selectedDay?.compare(today!) == ComparisonResult.orderedDescending{
            return true
        }
        else
        {
            return false
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            SwiftSpinner.show("資料刪除中")
            
            guard let outGoingList = outGoingList else {
                return
            }
            
            let outData = outGoingList.getOUtGoingData(date: selectDay!)
            let rest = clsRestful()
            rest.getJsonData("\(Global.apiUrl)DeleteOutgoing?OutId=\(outData[indexPath.row].m_OutId)&EmpNo=\(Global.UserId!)" ,onSuccess: {result -> Void in

                SwiftSpinner.hide()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let selectedDay = dateFormatter.date(from: self.selectDay!)
                
                
                let SDate = self.GetDateWithFormat(selectedDay!,format: "yyyyMM") + "01"
                let EDate = self.GetDateWithFormat(selectedDay!,format: "yyyyMM") + "31"
                
                self.dataBind(SDate: SDate, EDate: EDate)
                

            }, onError: {err -> Void in
                DispatchQueue.main.async(execute: {

                    SwiftSpinner.hide()

                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);

                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);

                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
            })
        }

            //tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
}

extension ViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 3
    }
}

extension ViewController:RefreshOutGoingData
{
    func refreshOutGoingData() {
        let SDate = GetDateWithFormat(Foundation.Date(),format: "yyyyMM") + "01"
        let EDate = GetDateWithFormat(Foundation.Date(),format: "yyyyMM") + "31"

        
        dataBind(SDate: SDate, EDate: EDate)
    }
}





