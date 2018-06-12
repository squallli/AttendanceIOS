//
//  LoginVC.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/27.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit


class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var lblUserName: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var atuoLogin: UISwitch!
    
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.gray
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.black.cgColor
        userNameText.delegate = self
        passwordText.delegate = self
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        lblVersion.text = "V \(appVersion)"
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Bool = prefs.bool(forKey: "ISLOGGEDIN") as Bool
        if (isLoggedIn  ) {
            SwiftSpinner.show("帳號驗證中...")
            login(prefs.object(forKey: "UserName") as! String,Password:prefs.object(forKey: "Password") as! String)
        } else {
            self.lblUserName.text = prefs.value(forKey: "UserName")  as? String
        }
    }
    
    @IBAction func logInClick(_ sender: AnyObject) {
        
        if lblUserName.text == "" || lblPassword.text == ""{
            let quetion = UIAlertController(title: "警告", message: "帳號或密碼不可為空白!", preferredStyle: .alert);
            
            let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
            
            quetion.addAction(okaction);
            self.present(quetion, animated: true, completion: nil);
            
            return
        }
        else{
            SwiftSpinner.show("帳號驗證中...")
            
            login(lblUserName.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,Password: lblPassword.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        }
        
        
    }
    
    func login(_ UserId:String,Password:String){
        
        let rest = clsRestful()
  
        let url:String = "\(Global.apiUrl)Login?LoginId=\(UserId)&LoginPwd=\(Password)".urlEncoded()
        rest.getJsonData(url,onSuccess: {result -> Void in
            
            let loginUser = LoginUser(json: result as! [String : Any])
            
            let isSuccess = loginUser.Result
            let prefs:UserDefaults = UserDefaults.standard
            
            if isSuccess == "1"{
                if let deviceToken = prefs.string(forKey:"deviceToken")
                {
                    rest.getJsonData("\(Global.apiUrl)RegDeviceToken?EmployeeNo=\(loginUser.UserId)&deviceToken=\(deviceToken)", onSuccess: {result -> Void in

                    }
                        , onError: {err -> Void in

                    })
                }
                
                if self.atuoLogin.isOn{
                    
                    if self.lblUserName.text != ""{
                        prefs.set(self.lblUserName.text, forKey: "UserName")
                    }
                    
                    if self.lblPassword.text != ""{
                        prefs.set(self.lblPassword.text, forKey: "Password")
                    }
                    
                    
                }
                
                prefs.set(self.atuoLogin.isOn, forKey: "ISLOGGEDIN")
                
                
                Global.UserId = loginUser.UserId
                Global.UserName = loginUser.UserName
                Global.UserEName = loginUser.UserEName
                Global.CompanyId = loginUser.Company
                
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "goto_login", sender: self)
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    let quetion = UIAlertController(title: "錯誤!", message: "登入失敗!", preferredStyle: .alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
            }
            
            

            },onError: {err -> Void in
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.hide()
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.present(quetion, animated: true, completion: nil);
                })
        })

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated
    }
    
}

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
