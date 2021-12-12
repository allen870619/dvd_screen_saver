//
//  ViewController.swift
//  dvdPlayerDemo
//
//  Created by Lee Yen Lin on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    var dvdCreator: DVDCreator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ＤＶＤ"
        
        dvdCreator = DVDCreator(mainView)
        dvdCreator.createDVD()
    }
   
    @IBAction func reset(_ sender: Any) {
        for i in mainView.subviews{
            i.layer.removeAllAnimations()
            i.removeFromSuperview()
        }
        dvdCreator.createDVD()
    }
}
