//
//  ContactUsViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    let str : String! = "You can Get In Touch with our 24/7 customer service agent anytime."
    override func viewDidLoad() {
        super.viewDidLoad()
     print("This screen for contact information .")
        // Do any additional setup after loading the view.
    
        let myMutableString = NSMutableAttributedString(string: self.str, attributes: [NSAttributedString.Key.font :UIFont(name: "ProximaNova-Regular", size: 17.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location:8,length:12))
    
    self.getInTouchLbl.attributedText = myMutableString
        self.popOverMenu.layer.cornerRadius = 15 
    
    }

    
    
    
    
    @IBAction func userProfileBtnClicked (_ sender: Any)
    {
        
        self.popOverMenu.removeFromSuperview()
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBOutlet weak var getInTouchLbl: UILabel!
    @IBAction func menuBtnClicked(_ sender: Any) {
    
//        let vc = TheSpaceDetailsViewController(nibName: "TheSpaceDetailsViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
    
    self.view.addSubview(popOverMenu)
        
//    popOverMenu.frame = CGRect(x: 140, y: 24, width: 375, height: 320)
        popOverMenu.frame = CGRect(x: 250, y: 26, width: 250, height: 100)
         popOverMenu.frame = CGRect(x: 250, y: 26, width: 250, height: 200)
    
    }
    
    @IBAction func donePopOverBtn(_ sender: Any) {
    
    self.popOverMenu.removeFromSuperview()
    }
    

    @IBAction func backbtnClicked(_ sender: Any) {
    
//    self.dismiss(animated: true, completion: nil)
self.navigationController?.popViewController(animated: true)
        
    }
    


    @IBOutlet var popOverMenu: UIView!
    


    @IBAction func AboutBtnClicked(_ sender: Any) {
          self.popOverMenu.removeFromSuperview()
        let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
//                self.present(vc, animated: true, completion: nil)
    
    self.navigationController?.pushViewController(vc, animated: true)
    }
    


    @IBAction func AvailableSpaceBtn(_ sender: Any) {
    
        let vc = AvailableSpaceViewController(nibName: "AvailableSpaceViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    
    }
    
    
    
    @IBAction func recentSpaceBtn(_ sender: Any) {
    
        let vc = RecentSpaceViewController(nibName: "RecentSpaceViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
    
    }
    

    @IBAction func submitBtnClicked(_ sender: Any) {
   
        let vc = RecentSpaceViewController(nibName : "RecentSpaceViewController", bundle : nil)
      
        
//        vc.uid = 
        self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    
}
