//
//  MainNavigationController.swift
//  HoldTheSpace
//
//  Created by Mac on 5/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MainNavigationController : UINavigationController{
    
   
    override func viewDidLoad() {
     super.viewDidLoad()
   
    self.isNavigationBarHidden = true
       view.backgroundColor = .white
       let isSuccess  = UserDefaults.standard.string(forKey: "isSuccess")
//        let isSuccess = "true"
        if (isSuccess == "true"){
            //Login Complete
         
            perform(#selector(chooseViewController), with: nil, afterDelay: 0.01)
        }else {
            perform(#selector(loginComplete), with: nil, afterDelay: 0.01)
         
            
            
    }
    }
    @objc func chooseViewController()
    {
        
        let userType = UserDefaults.standard.string(forKey: "userType")
        if userType == "seeker"{
            let vc = AvailableSpaceViewController()
//            viewControllers = [vc]

        pushViewController(vc, animated: true)
        }
        else {
            let vc = RecentSpaceViewController()
//            viewControllers = [vc]
        pushViewController(vc, animated: true)
        }
//        let vc = ListYourSpaceViewController()
//        pushViewController(vc, animated: true)
        
        
    }
    @objc func loginComplete ()
    {
        
        
        let vc = LoginViewController()
        pushViewController(vc, animated: true)
    }
    
    
    
}
