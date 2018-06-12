import Foundation


struct cardTimeData {
    let CardTime:String
    let CardType:String
    
    init(json:[String:Any])
    {
        CardTime = json["CardTime"] as? String ?? ""
        CardType = json["CardType"] as? String ?? ""
    }
}
