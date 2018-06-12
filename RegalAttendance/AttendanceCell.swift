

import UIKit

class AttendanceCell: UITableViewCell {
    

    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var dutyTimeLabel: UILabel!
    @IBOutlet weak var offDutyLabel: UILabel!
    @IBOutlet weak var offOverDutyLabel: UILabel!
    @IBOutlet weak var overDutyLabel: UILabel!
    
    func setCardType(_ cardType:String,cardTime:String){
        if cardType == "1"{
            if cardTime == ""
            {
                dutyTimeLabel.text = "無資料"
            }
            else
            {
                dutyTimeLabel.text = cardTime
            }
            
        }
        else if cardType == "2"{
            if cardTime == ""
            {
                offDutyLabel.text = "無資料"
            }
            else
            {
                offDutyLabel.text = cardTime
            }
            
        }
        else if cardType == "3"{
            if cardTime == ""
            {
                overDutyLabel.text = "無資料"
            }
            else
            {
                overDutyLabel.text = cardTime
            }
            
        }
        else if cardType == "4"{
            if cardTime == ""
            {
                offOverDutyLabel.text = "無資料"
            }
            else
            {
                offOverDutyLabel.text = cardTime
            }
        }
       
        
    }
    
 
    func clearData()
    {
        empNameLabel.text = ""
        dutyTimeLabel.text = ""
        offDutyLabel.text = ""
        offOverDutyLabel.text = ""
        overDutyLabel.text = ""
    }
    func setEmployeeName(_ EmployeeName:String){
        empNameLabel.text = EmployeeName
    }
    
  

}
