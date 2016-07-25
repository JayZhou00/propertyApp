//
//  filterViewController.swift
//  propertyApp
//
//  Created by Eric Zhou on 7/24/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit
import DropDown

class filterViewController: UIViewController {
    let typedropDown = DropDown()
    let cardropDown = DropDown()
    let pricedropDown = DropDown()
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var cart: UIButton!
    @IBOutlet weak var price: UIButton!

   
    override func viewDidLoad() {
       setupType()
     }

    func setupType(){
        typedropDown.anchorView = type
        typedropDown.bottomOffset = CGPoint(x: 0, y: type.bounds.height)
        typedropDown.dataSource = ["flat","villa"]
        typedropDown.selectionAction = {[unowned self] (index, item) in
            self.type.setTitle(item, forState: .Normal)
        }
    }
    func setupcart(){
        cardropDown.anchorView = type
        cardropDown.bottomOffset = CGPoint(x: 0, y: cart.bounds.height)
        cardropDown.dataSource = ["flat","villa"]
        cardropDown.selectionAction = {[unowned self] (index, item) in
            self.type.setTitle(item, forState: .Normal)
        }
    }
    func setupprice(){
        pricedropDown.anchorView = type
        pricedropDown.bottomOffset = CGPoint(x: 0, y: price.bounds.height)
        pricedropDown.dataSource = ["flat","villa"]
        pricedropDown.selectionAction = {[unowned self] (index, item) in
            self.type.setTitle(item, forState: .Normal)
        }
    }
    @IBAction func showtype(sender: AnyObject) {
        typedropDown.show()
    }
}
