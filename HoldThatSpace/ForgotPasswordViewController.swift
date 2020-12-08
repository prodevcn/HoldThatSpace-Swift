//
//  ForgotPasswordViewController.swift
//  HoldTheSpace
//
//  Created by Mac on 4/29/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
   print ("This screen is for forgot password . Enter Email Address ")
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.isHidden = true 
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func backBtnClicked(_ sender: Any) {
 self.navigationController?.popViewController(animated: true)
//self.dismiss(animated: true, completion: nil)

    }
    
    
    
    
    
    @IBAction func submitBtnClicked(_ sender: Any) {
 let url = "http://holdthatspace.com/webservices/userForgot.php"
    
self.callForgotPasswordWebservice(url : url)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()


    }
    

    func callForgotPasswordWebservice(url: String )
    {
        
        var sucessString : Int!
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let userName = self.emailTextField.text
        //        let passWord = self.passWordField.text
        let json: [String: Any] = ["emailId": userName!]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]{
                    print(responseJSON)
                    print(responseJSON["code"] as Any)
                    
                    
                    sucessString = responseJSON["code"] as? Int
                    
                    print(sucessString)
                    
                    //Check response from the sever
                    if sucessString == 200 {
                        OperationQueue.main.addOperation {
                            
                            //API call Successful and can perform other operatios
                            self.activityIndicator.stopAnimating()

                            let messageToShow = responseJSON["message"] as! String
                            print("Password  Successfully Updated ")
                            let alert = UIAlertController(title: "Password  Successfully Updated", message: messageToShow, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                     self.navigationController?.popViewController(animated: true)
                                    print("default")
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                            

                            
                        }
                        
                        
                    }
                        
                    else
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call failed and perform other operations
                            print("Password Updation Failed")
                            self.activityIndicator.stopAnimating()

                            let messageToShow = responseJSON["message"] as! String
                            let alert = UIAlertController(title: "Password Updation Failed", message: messageToShow, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                   
                                    print("default")
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                    
                }
            }
            catch {
                print("Error -> \(error)")
            }
            
            
            
        }
        
        
        task.resume()

        
        
        
    }




}
