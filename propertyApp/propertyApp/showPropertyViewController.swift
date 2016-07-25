//
//  showPropertyViewController.swift
//  propertyApp
//
//  Created by Eric Zhou on 7/22/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit
import XMSegmentedControl
import MapKit
import DropDown

class showPropertyViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate,XMSegmentedControlDelegate {
    
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var cart: UIButton!
    @IBOutlet weak var price: UIButton!
    let typedropDown = DropDown()
    let cardropDown = DropDown()
    let pricedropDown = DropDown()
    var p1 = ""
    var p2 = ""
    var p3 = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seg: XMSegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var searchController :UISearchController!
    var zipcodePlace:CLLocationCoordinate2D!
    @IBOutlet weak var collectioView: UICollectionView!
    var list:NSMutableArray! = []
    var flist:NSMutableArray = []
    var anotations:[MKAnnotation]! = []
    var fanotations:[MKAnnotation]! = []
    var selectedIndex:NSInteger! = 0
    var tindex:Int = 0
    var cindex:Int = 0
    var delegate :AppDelegate!
    var scollection:NSMutableArray = []
    var inthat:NSMutableDictionary = [:]
    
    func golist(){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("favoriteView")
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddeCollection()
        let image = UIImage.init(named: "favorites.png")
        image?.imageWithRenderingMode(.AlwaysOriginal)
        let btn = UIButton.init(type: .Custom)
        btn.setImage(image, forState: .Normal)
        btn.addTarget(self, action: #selector(showPropertyViewController.golist), forControlEvents: .TouchUpInside)
        btn.frame = CGRectMake(0, 0, 31, 31)
        btn.layer.cornerRadius = 15
        btn.imageView?.clipsToBounds = true
        
   
        let bt = UIBarButtonItem.init(customView: btn)
        self.navigationItem.leftBarButtonItem = bt
        fetchData()
        setupType()
        setupcart()
        setupprice()
//      findZip()
        delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let segmentedControl3 = XMSegmentedControl(frame: seg.layer.frame, segmentTitle: ["Map", "List"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.TopEdge)
        segmentedControl3.delegate = self
        segmentedControl3.backgroundColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 25/255, green: 180/255, blue: 145/255, alpha: 1)
        segmentedControl3.tint = UIColor.whiteColor()
        segmentedControl3.highlightTint = UIColor.blackColor()
        self.tableView.hidden = true
        self.view.addSubview(segmentedControl3)

        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        searchController.searchBar.backgroundColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        //        searchController!.searchBar.scopeButtonTitles = arr
         self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.whiteColor()
         self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true;
        self.searchController.searchBar.tintColor = UIColor.colorWithHex("#33CC00", alpha: 1)
//        self.searchController.searchBar.backgroundColor = UIColor.whiteColor()
        
        self.searchController.searchBar.sizeToFit()
        
        }
    
    //table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return flist.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("tcell") as! tableCell
        var price = flist[indexPath.row]["Property Cost"] as! String
        price =  "price : " + price + "/mo"
        var type = flist[indexPath.row]["Property Type"] as! String
        type =  "type : " + type
        var size = flist[indexPath.row]["Property Size"] as! String
        size =  "size : " + size
        cell.price.text = price
        cell.type.text = type
        cell.size.text = size
        cell.tag = tindex
        tindex += 1
        cell.tlove.tag = tindex
        tindex += 1
        
        let lol = flist[indexPath.row]["Property Id"] as! String
        let all = delegate.savedList.allKeys as! [String]
        cell.tlove.selected = false
        for one in all {
            if lol == one{
                cell.tlove.selected = true
                break
            }
        }

//        let x = flist[indexPath.row]["select"] as! String
//        if(x == "1"){
//            cell.tlove.selected = true
//        }else{
//            cell.tlove.selected = false
//        }

        return cell

        
    }
    
    //search
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        let predic = NSPredicate(format: "SELF contains[c] %@",searchBar.text!)
        let predic2 = NSPredicate(format: "SELF contains[c] %@",p1)
        let predic3 = NSPredicate(format: "SELF contains[c] %@",p2)
        let predic4 = NSPredicate(format: "SELF contains[c] %@",p3)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predic2, predic3,predic4,predic])
        
        let x = list.filteredArrayUsingPredicate(predicate)
        flist = NSMutableArray(array: x)
        self.refreshAno()
        self.cindex = 0
        self.tindex = 0
        self.collectioView.reloadData()
        self.tableView.reloadData()

        showCollectio()
    }
    //seg
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        if selectedSegment == 0{
            UIView.animateWithDuration(1, animations: {
                self.tableView.hidden = true
                self.cindex = 0

                self.collectioView.reloadData()
            })
        }else{
            UIView.animateWithDuration(1, animations: {
                self.tableView.hidden = false

                self.tindex = 0
                dispatch_async(dispatch_get_main_queue(), {
                     self.tableView.reloadData()
                })
               
            })
            
        }
    }
    //search delegate
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if(searchController.searchBar.text == ""){
            flist = list.mutableCopy() as! NSMutableArray
            self.refreshAno()
            self.cindex = 0
            self.tindex = 0
            self.collectioView.reloadData()
            self.tableView.reloadData()
            showCollectio()
        }
    }
    //refrsh
    
    func refreshAno(){
        self.mapView.removeAnnotations(mapView.annotations)
        var i:Int = 0
        fanotations = []
        for x in flist{
            let anotation :MKAnnotation!
            let lat = x["Property Latitude"] as! CLLocationDegrees
            let lon = x["Property Longitude"] as! CLLocationDegrees
            let cor = CLLocationCoordinate2D.init(latitude:lat , longitude:lon)
            anotation = MapPin.init(coordinate: cor, title: "aloha", subtitle:"",index:i)
            i += 1
            fanotations.append(anotation)
            
        }
        self.mapView.addAnnotations(fanotations)

    }
    //map
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //data
    func fetchData(){
        let url = NSURL(string: "http://www.rjtmobile.com/realestate/getproperty.php?all")
        let request = NSMutableURLRequest(URL: url!)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if(error == nil){
                do{
                    if let json:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                        
                        self.list = json as! NSMutableArray
                        self.scollection = self.list.mutableCopy() as! NSMutableArray
                        for one in self.scollection{
                            let x = one as! NSMutableDictionary
                            x.setValue("0", forKey: "select")
                        }
                        self.flist = self.scollection.mutableCopy() as! NSMutableArray
                        self.list = self.scollection.mutableCopy() as! NSMutableArray

                        self.showAnnotation()
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.cindex = 0
                            self.tindex = 0
                            self.collectioView.reloadData()
                            self.tableView.reloadData()
                            self.showCollectio()
                        })
                       
//                        print(json)
                    
                    }
                }catch{
                    print(error)
                }
  
            }
        }.resume()
    }
    //zipcode
    func findZip(){
        let adress = "60174"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { (placemarks, error) in
            if let placemark = placemarks?[0]  {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.zipcodePlace = placemark.location!.coordinate
                let initialLocation = CLLocation(latitude: self.zipcodePlace.latitude, longitude: self.zipcodePlace.longitude)
                self.centerMapOnLocation(initialLocation)

            }
        }
    }
    
    //showannotation
    func showAnnotation() {
        var i:Int = 0
        for x in flist{
            let anotation :MKAnnotation!
            let lat = x["Property Latitude"] as! CLLocationDegrees
            let lon = x["Property Longitude"] as! CLLocationDegrees
            let cor = CLLocationCoordinate2D.init(latitude:lat , longitude:lon)
            anotation = MapPin.init(coordinate: cor, title: "hello", subtitle:"",index:i)
            i += 1
            anotations.append(anotation)

        }
        self.mapView.addAnnotations(anotations)
    }
    
    //which annotation tapped
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        if let ano = view.annotation as? MapPin{
           self.selectedIndex = ano.index
        let indexToScrollTo = NSIndexPath(forRow:selectedIndex, inSection: 0)
        self.collectioView.scrollToItemAtIndexPath(indexToScrollTo, atScrollPosition: .Left, animated: false)
 
        }
    }
   //show collectiom
    func hiddeCollection(){
    
        collectioView.bounds = CGRectOffset(collectioView.bounds, 0, -300)
         collectioView.setNeedsLayout()
    }
    func showCollectio(){
        UIView.animateWithDuration(1) { 
            self.collectioView.bounds = CGRectOffset(self.collectioView.bounds, 0, 300)
            self.collectioView.setNeedsLayout()
        }
    
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return flist.count
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = self.collectioView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! collectionCell
        var price = flist[indexPath.row]["Property Cost"] as! String
        price =  "price : " + price
        var type = flist[indexPath.row]["Property Type"] as! String
        type =  "type : " + type
        var size = flist[indexPath.row]["Property Size"] as! String
        size =  "size : " + size
        cell.price.text = price
        cell.type.text = type
        cell.size.text = size
        cell.tag = cindex
        cindex += 1
        cell.clove.tag = cindex
        cindex += 1
//        let x = flist[indexPath.row]["select"] as! String
        let lol = flist[indexPath.row]["Property Id"] as! String
        let all = delegate.savedList.allKeys as! [String]
        
// put before loop
        
        
        cell.clove.selected = false
        for one in all {
            if lol == one{
                cell.clove.selected = true
                break
            }
        }
        
        
//        if(x == "1"){
//            cell.clove.selected = true
//        }else{
//            cell.clove.selected = false
//        }
        return cell
    }
    
    //anotation image
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        print("delegate called")
        
        if !(annotation is MapPin) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
//        let cpa = annotation as! MapPin
        anView!.image = UIImage(named:"pin.png")
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(size)
        anView?.image!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        anView?.image = resizedImage

        
        return anView
    }
    
    @IBAction func tlove(sender: UIButton) {
        let key = flist[sender.tag/2]["Property Id"] as! String
        if(!sender.selected){
            delegate.savedList.setValue(flist[sender.tag/2], forKey: key)
            flist[sender.tag/2].setValue("1", forKey: "select")
        }else{
            delegate.savedList.removeObjectForKey(key)
             flist[sender.tag/2].setValue("0", forKey: "select")
        }
        sender.selected = !sender.selected
    }
    @IBAction func clove(sender: UIButton) {
        let key = flist[sender.tag/2]["Property Id"] as! String
        if(!sender.selected){
            delegate.savedList.setValue(flist[sender.tag/2], forKey: key)
            flist[sender.tag/2].setValue("1", forKey: "select")
        }else{
            delegate.savedList.removeObjectForKey(key)
             flist[sender.tag/2].setValue("0", forKey: "select")
        }
        sender.selected = !sender.selected
        
    }
    //select tablecell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
        controller.house = flist[indexPath.row]
        self.presentViewController(controller, animated: true, completion: nil)
    }
    //select collectioncell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
        controller.house = flist[indexPath.row]
         self.presentViewController(controller, animated: true, completion: nil)

    }
    
    override func viewWillDisappear(animated: Bool) {

        let defu = NSUserDefaults.standardUserDefaults()
        let ID = defu.valueForKey("ID") as! String
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        defu.setValue(delegate.savedList, forKey:ID)
    }
    
    //setup dropdown
    func setupType(){
        typedropDown.anchorView = type
        typedropDown.bottomOffset = CGPoint(x: 0, y: type.bounds.height)
        typedropDown.dataSource = ["flat","villa","office","house","plot","all"]
        typedropDown.selectionAction = {[unowned self] (index, item) in
            self.p1 = item
            self.type.setTitle(item, forState: .Normal)
        }
    }
    func setupcart(){
        cardropDown.anchorView = type
        cardropDown.bottomOffset = CGPoint(x: 0, y: cart.bounds.height)
        cardropDown.dataSource = ["buy","rent","either"]
        cardropDown.selectionAction = {[unowned self] (index, item) in
            self.p2 = item
            self.cart.setTitle(item, forState: .Normal)
        }
    }
    func setupprice(){
        pricedropDown.anchorView = type
        pricedropDown.bottomOffset = CGPoint(x: 0, y: price.bounds.height)
        pricedropDown.dataSource = ["less","500/mo","800/mo","1300/mo","1800/mo","2300/mo","more","anyway"]
        pricedropDown.selectionAction = {[unowned self] (index, item) in
            self.p3 = item
            self.price.setTitle(item, forState: .Normal)
        }
    }
    @IBAction func showtype(sender: AnyObject) {
        typedropDown.show()
    }
    @IBAction func showcater(sender: AnyObject) {
        cardropDown.show()
    }
    @IBAction func showprice(sender: AnyObject) {
        pricedropDown.show()
    }


}
class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var index:Int!
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String,index:Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.index = index
    }
}