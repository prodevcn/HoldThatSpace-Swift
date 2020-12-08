//
//  AboutUsViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print ("This Screen is About HTS Product For Parking OF Vehcile  .")
        self.menuPopOver.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }

    @IBAction func profileBtnClicked(_ sender: Any) {
    
    
        self.menuPopOver.removeFromSuperview()
        
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
self.navigationController?.pushViewController(vc, animated: true)
    
     
    
    
    }
    
    @IBAction func bckBtnClicked(_ sender: Any) {
           self.menuPopOver.removeFromSuperview()
//        self.dismiss(animated: true, completion: nil)
self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
//        let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
        self.view.addSubview(menuPopOver)
//        menuPopOver.frame = CGRect(x: 140, y: 26, width: 200, height: 100)
//        menuPopOver.frame = CGRect(x: 250, y: 26, width: 250, height: 100)
        menuPopOver.frame = CGRect(x: 250, y: 26, width: 250, height: 200)
        
        
        
        
    }
    
    
    
    
    
  
    
    @IBAction func availableSpaceBtnClicked(_ sender: Any) {
             self.menuPopOver.removeFromSuperview()
                let vc = AvailableSpaceViewController(nibName: "AvailableSpaceViewController", bundle: nil)
//                self.present(vc, animated: true, completion: nil)
    
    
    }
    
    @IBOutlet var menuPopOver: UIView!
    
//    override func viewWillAppear(_ animated: Bool) {
//       self.menuPopOver.removeFromSuperview()
//    }
    
   override func viewDidAppear(_ animated: Bool) {
        self.menuPopOver.removeFromSuperview()
    }
    
    
    
    @IBAction func recentSpaceBtnClicked(_ sender: Any) {
        
        self.menuPopOver.removeFromSuperview()
        
        let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    
    
    @IBAction func doneBtnclicked(_ sender: Any) {
    
    self.menuPopOver.removeFromSuperview()
    
    }
    
    
}
