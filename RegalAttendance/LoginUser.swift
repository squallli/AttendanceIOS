//
//  mLogin.swift
//  RegalAttendance
//
//  Created by 宗桓 李 on 2017/9/11.
//  Copyright © 2017年 Regal System. All rights reserved.
//

import Foundation

struct LoginUser {
    let Result:String
    let UserId:String
    let UserName:String
    let UserEName:String
    let Company:String
    let CompanyName:String
    
    init(json:[String:Any])
    {
        Result = json["Result"] as? String ?? ""
        UserId = json["UserId"] as? String ?? ""
        UserName = json["UserName"] as? String ?? ""
        UserEName = json["UserEName"] as? String ?? ""
        Company = json["Company"] as? String ?? ""
        CompanyName = json["CompanyName"] as? String ?? ""
    }
}
