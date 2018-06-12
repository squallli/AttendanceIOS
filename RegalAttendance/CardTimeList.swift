
import Foundation

struct CardTimeList
{
    var cardTimelist : [cardTimeData]
    let EmployeeNo:String
    let EmployeeName:String
    let EmployeeEName:String
    let CardDate:String
    
    init(json:[String:Any])
    {
        cardTimelist = [cardTimeData]()
        self.EmployeeNo = json["EmployeeNo"] as? String ?? ""
        self.EmployeeName = json["EmployeeName"] as? String ?? ""
        self.EmployeeEName = json["EmployeeEName"] as? String ?? ""
        self.CardDate = json["CardDate"] as? String ?? ""
        
        guard let cardList = json["CardTimeList"] as? NSArray else{return}
        
        for card in cardList
        {
            self.cardTimelist.append(cardTimeData(json: card as! [String : Any]))
        }
        
    }
}

struct CardData {
    var cardData:[CardTimeList]
    
    func getCardData(date:String)->CardTimeList?
    {
        for card in cardData
        {
            if card.CardDate == date {return card}
        }
        
        return nil
    }

    
    func Contains(date:String)->Bool
    {
       for card in cardData
       {
        if card.CardDate == date {return true}
       }
        
       return false
    }
    
    init(json:[[String:Any]])
    {
        cardData = [CardTimeList]()
        
        for card in json{
            cardData.append(CardTimeList(json: card))
        }
    }
}
