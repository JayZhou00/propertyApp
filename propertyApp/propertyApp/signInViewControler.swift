//
//  signInViewControler.swift
//  propertyApp
//
//  Created by Eric Zhou on 7/22/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit
import DropDown

class signInViewControler: UIViewController,UIViewControllerTransitioningDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var button : HyLoginButton!
    let typedropDown = DropDown()
    @IBOutlet weak var type: UIButton!
    
    @IBOutlet weak var bimage: UIImageView!
    var user: AnyObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupType()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        button = HyLoginButton.init(frame: CGRectMake(50, CGRectGetHeight(self.view.bounds)-(40 + 70), UIScreen.mainScreen().bounds.size.width - 90, 40))
        button.backgroundColor = UIColor.colorWithHex("#BBBBBB", alpha: 1)
        button.setTitle("Log in", forState: .Normal)
        button.addTarget(self, action:#selector(signInViewControler.PresentViewController(_:)),forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
       bimage.image = UIImage.gifWithName("building")
        bimage.clipsToBounds = true

    }
    
    func PresentViewController(button:HyLoginButton)  {
        
        let string = "http://rjtmobile.com/realestate/register.php?login"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
//        request.allHTTPHeaderFields = ["email":"test@gmail.com","password":"asdf"]
        let bodyData = "email=test@gmail.com&password=asdf&usertype=seller"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if(error == nil){
                do {
                    if let json:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                        print(json)
                        self.user = json
                        let ID = self.user[0]["User Id"] as! String
                        let defu = NSUserDefaults.standardUserDefaults()
                        defu.setValue(ID, forKey: "ID")
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        if let list = defu.valueForKey(ID) as? NSMutableDictionary{
                            delegate.savedList = list.mutableCopy() as! NSMutableDictionary
                        }
                        
                        
                    }
                }catch{
                    
                }
            }
        }.resume()
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (__int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            if (self.user != nil){
                button.succeedAnimationWithCompletion({
                    self.goNav()
                })
            }else{
                button.failedAnimationWithCompletion({
                    
                })
            
            }
        }
    }
    
    
    func goNav(){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("showPn") as! UINavigationController
        controller.transitioningDelegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func loginButton(enabled: Bool) -> () {
        
        func enable(){
            UIView.animateWithDuration(0.9, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.button.backgroundColor = UIColor.colorWithHex("#33CC00", alpha: 1)
                }, completion: nil)
            button.enabled = true
        }
        func disable(){
            button.enabled = false
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.button.backgroundColor = UIColor.colorWithHex(" #11111111", alpha: 1)
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(userName.text != "" && password.text != ""){
            loginButton(true)
        }else{
            loginButton(false)
        }
        return true
    }
    
    func setupType(){
        typedropDown.anchorView = type
        typedropDown.bottomOffset = CGPoint(x: 0, y: type.bounds.height)
        typedropDown.dataSource = ["seller","buyer"]
        typedropDown.selectionAction = {[unowned self] (index, item) in
            self.type.setTitle(item, forState: .Normal)
        }
    }
    @IBAction func showtype(sender: AnyObject) {
        typedropDown.show()
    }
    
//move frame
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        moveFrame(true)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        moveFrame(false)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userName.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func moveFrame(up:Bool){
        if up{
            UIView.animateWithDuration(0.5, animations: {
                self.view.bounds = CGRectOffset(self.view.bounds, 0, 150)
                self.view.setNeedsLayout()
            })
            
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.view.bounds = CGRectOffset(self.view.bounds, 0, -150)
                self.view.setNeedsLayout()
                
            })
        }
        
    }

}
extension UIColor{
    
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0;
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}