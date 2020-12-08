//
//  PaymentViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController{

    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController)
    {
        print ("PayPal Payment cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
        
    }
    func payPalPaymentViewController (_ paymentViewController : PayPalPaymentViewController, didComplete completedPayment : PayPalPayment)
    {
        print ("payPal apyemnet Success")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            
            print ("paymentInfo:", completedPayment.confirmation)
            
            
        })
      
    
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment : environment)
    }
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    @IBAction func paymentBtnClicked(_ sender: Any) {
    
    
       
        
    
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
  print("This shows all the payments & transactions of spotter.")
      
        // Do any additional setup after loading the view.
    }


}
