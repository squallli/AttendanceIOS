//
//  clsOutgoing.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/26.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import Foundation

struct  clsOutgoing
{
    let m_outDate:String
    let m_outTime:String
    let m_customer:String
    let m_Location:String
    let m_OutId:String
    let m_MettingTime:String
    
    
    init(json:[String:Any]){
        m_outDate = json["OutDate"] as? String ?? ""
        m_outTime = json["OutTime"] as? String ?? ""
        m_customer = json["CustomerName"] as? String ?? ""
        m_Location = json["Location"] as? String ?? ""
        m_OutId = json["OutId"] as? String ?? ""
        m_MettingTime = json["GoOutTime"] as? String ?? ""
        
    }
}

struct clsOutGoingList {
    var OutGoingList:[clsOutgoing] = []
    
    func getOutGoingCount(date:String) -> Int
    {
        var count:Int = 0
        
        for data in OutGoingList
        {
            if(data.m_outDate == date)
            {
                count += 1
            }
        }
        
        return count
    }
    
    
    func getOUtGoingData(date:String) -> [clsOutgoing]
    {
        var currentOutDataList = [clsOutgoing]()
        
        for outGoingData in OutGoingList
        {
            if( outGoingData.m_outDate == date)
            {
                currentOutDataList.append(outGoingData)
            }
        }
        
        return currentOutDataList
    }
    
    func Count() -> Int {
        return OutGoingList.count
    }
    
    init(json:[[String:Any]])
    {
        for data in json
        {
            self.OutGoingList.append(clsOutgoing(json: data))
        }
    }
    
    func Contains(date:String) -> Bool
    {
        for outGoingData in OutGoingList
        {
            if( outGoingData.m_outDate == date)
            {
                return true;
            }
        }
        return false;
    }
}
