

import UIKit


class ActivityIndicator: NSObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public class var shared: ActivityIndicator
    {
        struct Static
        {
            static let instance: ActivityIndicator = ActivityIndicator()
        }
        return Static.instance
    }
    
    public func startProgressView(){
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startActivityIndicator()
        /*IHProgressHUD.set(defaultMaskType: .gradient)
        IHProgressHUD.set(defaultStyle: .light)
        IHProgressHUD.set(viewForExtension: view)
        IHProgressHUD.set(foregroundColor: .areaBasedColor)
        IHProgressHUD.show()
        UIApplication.shared.beginIgnoringInteractionEvents()*/
        //IHProgressHUD.set(font: UIFont.init(name:"Kanun AR+LT-Bold", size: 13)!)
    }
    
    public func stopProgressView()
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopActivityIndicator()
      //  IHProgressHUD.dismiss()
       // UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    public func checkActivityIndicatior() -> Bool
    {
        return appDelegate.checkActivityIndicatior()
    }
}
