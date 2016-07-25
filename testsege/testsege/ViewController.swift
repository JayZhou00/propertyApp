//
//  ViewController.swift
//  testsege
//
//  Created by Eric Zhou on 7/22/16.
//  Copyright © 2016 Jay Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,YSSegmentedControlDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let segmented = YSSegmentedControl(
            frame: CGRect(
                x: 0,
                y: 64,
                width: view.frame.size.width,
                height: 44),
            titles: [
                "Map",
                "List"
            ])
        self.navigationController?.navigationBarHidden = true
            segmented.delegate = self
            view.addSubview(segmented)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func segmentedControlWillPressItemAtIndex (segmentedControl: YSSegmentedControl, index: Int){
       
        if index == 0{
            view1.hidden = true
        }else{
            view1.hidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

