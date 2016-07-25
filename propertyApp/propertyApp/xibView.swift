//
//  xibView.swift
//  XibTest
//
//  Created by Stanislav on 02.07.16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

import UIKit


protocol DatePickerDelegate: class {
    
    func buttonPikcerDidPress(title: String)
}


@IBDesignable class xibView: UIView {

    @IBOutlet private weak var dayOfMonthLabel: UILabel!
    @IBOutlet private weak var monthAndDayOfWeekLabel: UILabel!
    @IBOutlet private weak var starTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var titleDateLabel: UILabel!
    
    
    var view: UIView!
    private var nibName = "xibViewNext"
    weak var delegate: DatePickerDelegate?
    
    
    @IBInspectable var titleDateText: String {
        get {
            return titleDateLabel.text!
        }
        set(text) {
            titleDateLabel.text = text
        }
    }
    
    var startTime: NSDate?
    
    var startTimeLabels: NSDate {
        get {
            return startTime!
        }
        set(date) {
            startTime = date
            dayOfMonthLabel.text = NSDate().formatDateToString(date, format: "dd")
            monthAndDayOfWeekLabel.text = NSDate().formatDateToString(date, format: "E | MMMM")
            starTimeLabel.text = NSDate().formatDateToString(date, format: "HH:mm")
        }
    }
    
    var endTimeLabels: NSDate {
        get {
            return NSDate()
        }
        set(date) {
            endTimeLabel.text = NSDate().formatDateToString(date, format: "HH:mm")
        }
    }
    
    
    
    
    //////////
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    
    
    /////////////

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func loadFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        return view
    }

    private func setup() {
        let view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
    }
    
    //MARK:- IBActions
    @IBAction func datePicker(sender: UIButton) {
        delegate?.buttonPikcerDidPress(titleDateText)
    }

}

extension NSDate {
    
    func formatDateToString(date: NSDate, format: String) -> String {
        let formater = NSDateFormatter()
        formater.dateFormat = format
        return formater.stringFromDate(date)
    }

}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

