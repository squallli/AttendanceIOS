//
//  clsJason.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/26.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import Foundation

class clsRestful {
    
    init(){
        
    }

    func makePostRequest(_ url:String,postData:[String:Any],onSuccess: @escaping (_ result: Any) -> Void,onError:@escaping (_ err: String)-> Void) -> Void
    {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        //let postString = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: postData, options: [])
        
        
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if(error != nil) {
                onError(error!.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response.debugDescription)")
            }
            
            
            do{
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                onSuccess(json)
            }
            catch let jsonErr{
                onError(jsonErr.localizedDescription )
            }

        }
        
        
        task.resume()
        
        
    }

    
    func getJsonData(_ Url:String,onSuccess: @escaping (_ result: Any) -> Void,onError: @escaping (_ err: String)-> Void) -> Void
    {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        
        let urlPath = Url
        let url = URL(string: urlPath)
        
 
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: url!,
                                    completionHandler: {
                data,
                response,
                error -> Void in
                
                if(error != nil) {
                    onError(error!.localizedDescription)
                    return
                }
                
                //guard let data = data else {return}
                                        
                                        
                do{
                    
                 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    onSuccess(json)
                }
                catch let jsonErr{
                    onError(jsonErr.localizedDescription )
                }
                
     
        })
        
        task.resume()
    }
    
    
}

