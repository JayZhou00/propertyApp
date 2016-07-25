//
//  favoriteViewController.swift
//  propertyApp
//
//  Created by Eric Zhou on 7/22/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit

class favoriteViewController: UIViewController {
    var delegate:AppDelegate! = nil
    var flist:NSMutableArray!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        delegate = UIApplication.sharedApplication().delegate as!AppDelegate
        let image = UIImage.gifWithName("mountain")
        let headerView: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithImage(image, forSize: CGSizeMake(self.tableview.frame.size.width
            , 180)) as! ParallaxHeaderView
        
        self.tableview.tableHeaderView = headerView
        
    }
    func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableview.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableview.tableHeaderView = header
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return delegate.savedList.allValues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cell") as! tableCell2
        let list = delegate.savedList.allValues
        flist = NSMutableArray(array: list)
        var price = flist[indexPath.row]["Property Cost"] as! String
        price =  "price : " + price + "/mo"
        var type = flist[indexPath.row]["Property Type"] as! String
        type =  "type : " + type
        var size = flist[indexPath.row]["Property Size"] as! String
        size =  "size : " + size
        cell.price.text = price
        cell.type.text = type
        cell.size.text = size
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            flist.removeObjectAtIndex(indexPath.row)
            let key = flist[indexPath.row]["Property Id"] as! String
            delegate.savedList.removeObjectForKey(key)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        
        let defu = NSUserDefaults.standardUserDefaults()
        let ID = defu.valueForKey("ID") as! String
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        defu.setValue(delegate.savedList, forKey:ID)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
        controller.house = flist[indexPath.row]
        self.presentViewController(controller, animated: true, completion: nil)

    }

}
