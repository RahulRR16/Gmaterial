

import UIKit
import Alamofire


class ServiceHandler: NSObject {
    
    var reachability = Reachability()!
    
    static let sharedInstance = ServiceHandler()
    
    //MARK:- Network Reachability Manager
    func networkReachabilityManager(sender : Any){
        
        
        let reachabilityManager = NetworkReachabilityManager()
        
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            
            switch status {
            case .notReachable:
                print("The network is not reachable")
                self.alertViewWithMessage(message: "Please check your internet connection and try again!")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular connection")
            }
        })
        
        
    }
    
   
    
    func getRequestURL(_ strURL: String,isloader: Bool,success:@escaping ([Any], Data) -> Void, failure:@escaping (Error) -> Void) {
        
        if !(self.isConnectedToNetwork())
        {
            DispatchQueue.main.async {
                ActivityIndicator.shared.stopProgressView()
            }
             
        }
        
        //-- Start Loader
        if isloader{
              ActivityIndicator.shared.startProgressView()
        }
        
        let url: String = strURL
        
        let queryURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        var request = URLRequest(url:  NSURL(string: queryURL)! as URL)
        
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).validate(statusCode: 200..<300).responseJSON { responseData in
            
            switch responseData.result {
            case let .success(result):
                let resJson = result
                let resData = responseData.data
                
                success(resJson as? [Any] ?? [], resData ?? Data())
               
             print("Result is: \(result)")
            case let .failure(error):
               // Handle the error.
                let error : Error = responseData.error!
                failure(error)
             print("Error description is: \(error.localizedDescription)")
            }
            //-- Stop Loader
            if isloader{
                DispatchQueue.main.async {
                    ActivityIndicator.shared.stopProgressView()
                }
            }
            
        }
    }
    
    func alertViewWithMessage(message : String){
        
        let alertSuccess = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction (title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertSuccess.addAction(okAction)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertSuccess, animated: true, completion: nil)
            // topController should now be your topmost view controller
        }
        
    }
    
    func isConnectedToNetwork() -> Bool{
        
        if !((Reachability()?.isReachable)!)
        {
             ActivityIndicator.shared.stopProgressView()
            self.alertViewWithMessage(message: "Please ensure you are connected to the internet.")
            
        }
        
        if let reachabilityStatus = Reachability()?.isReachable{
            return reachabilityStatus
        }
        return false
    }
    
}


