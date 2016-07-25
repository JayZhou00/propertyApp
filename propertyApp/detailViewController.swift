//
//  detailViewController.swift
//  propertyApp
//
//  Created by Eric Zhou on 7/24/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit
import MessageUI

class detailViewController: UIViewController ,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    var house:AnyObject!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var pdate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var adress1: UILabel!
    @IBOutlet weak var adress2: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var price: UILabel!
    var info :NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchInfo()
        pdate.text = house["Property Published Date"] as? String
        name.text = house["Property Name"] as? String
        type.text = house["Property Type"] as? String
        adress1.text = house["Property Address1"] as? String
        adress2.text = house["Property Address2"] as? String
        zip.text = house["Property Zip"] as? String
        price.text = house["Property Cost"] as? String
        let x = house["select"] as? String
        if(x == "1"){
        savedButton.selected = true
        }else{
        savedButton.selected = false
        }
    }

    func fetchInfo(){
        let ID = house["User Id"] as! String
        let reuqest = NSMutableURLRequest(URL: NSURL(string: ID)!)
        NSURLSession.sharedSession().dataTaskWithRequest(reuqest) { (data, response, error) in
            do{
                if let json:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                    self.info = json as! NSMutableDictionary
                }
            }catch{
            
            }
        }.resume()
    
    }
    @IBAction func save(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let key = house["Property Id"] as! String
        delegate.savedList.removeObjectForKey(key)

    }
    
    @IBAction func share(sender: AnyObject) {
        let share = UIActivityViewController.init(activityItems: ["Yo","I found something Interseting"], applicationActivities: nil)
        self.presentViewController(share, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func call(sender: AnyObject) {
        let phoneNumber = "123"
//        let phoneNumber = info.valueForKey("phonenumber") as! String
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    @IBAction func sendemail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["nurdin@gmail.com"])
//        let email = info.valueForKey("email") as! String
//        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func sendsms(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "YO,I found something Interseting";
//        let phoneNumber = info.valueForKey("phonenumber") as! String
//        messageVC.recipients = [phoneNumber]
        messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    //MESSAGE DELEGATE
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    override func viewWillDisappear(animated: Bool) {
        
        let defu = NSUserDefaults.standardUserDefaults()
        let ID = defu.valueForKey("ID") as! String
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        defu.setValue(delegate.savedList, forKey:ID)
    }

  
}
