
import UIKit

class OutgoingViewController: UITableViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var buttonEstOutDate: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var textCustomer: UITextField!
    @IBOutlet weak var textPalce: UITextField!
    @IBOutlet weak var buttonArrivalTime: UIButton!
    
    var delegate:RefreshOutGoingData?
    var defaultDate:NSDate?
    
    override func viewDidLoad() {
        textCustomer.delegate = self
        textPalce.delegate = self
        
        textCustomer.autocorrectionType = UITextAutocorrectionType.no
        textPalce.autocorrectionType = UITextAutocorrectionType.no
        
        let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        
        buttonDate.setTitle(dateFormatter.string(from: defaultDate! as Date), for: UIControlState())
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showMessage(_ msg:String)
    {
        let quetion = UIAlertController(title: "錯誤!", message: msg, preferredStyle: .alert);
        
        let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
        
        quetion.addAction(okaction);
        self.present(quetion, animated: true, completion: nil);
    }

    @IBAction func buttonClickSave(_ sender: UIButton) {
        
        if textPalce.text == "" {
            showMessage("外出地點不能為空白!")
            return
        }
        
        if textCustomer.text == "" {
            showMessage("客戶不能為空白!")
            return
        }
        
        SwiftSpinner.show("儲存外出中")
        
        let json = ["OutMan":Global.UserId ,"OutManCompany":Global.CompanyId,"SDate":buttonDate.titleLabel?.text,"STime":buttonEstOutDate.titleLabel?.text ,"Location":textPalce.text! ,"CustomerName":textCustomer.text ,"OutDescription":"" ,"GoOutTime":buttonArrivalTime.titleLabel?.text ] as [String : Any]

        let rest = clsRestful()
        
        
        rest.makePostRequest("\(Global.apiUrl)InsertOutgoing", postData: json, onSuccess: {result -> Void in
            
            guard let result = result as? [String:Any] else {
                return
            }
            
            if result["Result"] as! String == "1" {
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    self.delegate?.refreshOutGoingData()
                    
                    self.dismiss(animated: true, completion: nil)
                   
                })
            }
            else{
                let quetion = UIAlertController(title: "錯誤!", message: result["ErrorMsg"] as? String ?? "", preferredStyle: .alert);
                
                let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                
                quetion.addAction(okaction);
                self.present(quetion, animated: true, completion: nil);
            }
           
            
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
    
    func GetDateWithFormat(_ d:Foundation.Date,format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let s = dateFormatter.string(from: d)
        
        return s
    }
    
    @IBAction func btnOutDateClick(_ sender: UIButton) {
        
        if sender.tag == 0 {
            DatePickerDialog().show("選擇跟客戶約定期", doneButtonTitle: "完成", cancelButtonTitle: "取消",defaultDate: defaultDate! as Date, datePickerMode: .date) {
                (date) -> Void in
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.buttonDate.setTitle(dateFormatter.string(from: date), for: UIControlState())
            }
        }
        else if sender.tag == 1 {
            DatePickerDialog().show("選擇預計外出時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .time) {
                (date) -> Void in
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "HH:mm"
                
                self.buttonEstOutDate.setTitle(dateFormatter.string(from: date), for: UIControlState())
            }
        }
        else if sender.tag == 2 {
            DatePickerDialog().show("選擇會議時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .time) {
                (date) -> Void in
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "HH:mm"
                
                self.buttonArrivalTime.setTitle(dateFormatter.string(from: date), for: UIControlState())
            }
        }
        

    }
    
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
}
