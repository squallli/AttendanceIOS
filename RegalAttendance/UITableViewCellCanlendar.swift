//
//  UITableViewCellCanlendarTableViewCell.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/22.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit

class UITableViewCellCanlendarTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelCustomer: UILabel!
   
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var LableDate: UILabel!
    
    @IBOutlet weak var LablemettingTime: UILabel!
 
    @IBOutlet weak var LableoutTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMettingTime(mettingtime:String)
    {
        LablemettingTime.text = "會議時間:\(mettingtime)"
    }
    
    func setOutTime(outTime:String)
    {
        LableoutTime.text = "外出時間:\(outTime)"
    }
    
    
    func setCustomer(_ customer:String)
    {
        LabelCustomer.text! = "客戶:\(customer)"
    }
    
    func setLocation(_ Location:String)
    {
        LabelLocation.text! = "地點:\(Location)"
    }
    
    func setDate(_ Date:String)
    {
        LableDate.text! = "日期:\(Date)"
    }

}
