//
//  SignUpViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var hideUnhideConPassBtn: UIButton!
    
    @IBOutlet weak var hideUnhidePassBtn: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    var iconClick = true
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        FirstNameField.resignFirstResponder()
        LastNameField.resignFirstResponder()
        EmailAddressField.resignFirstResponder()
        PasswordField.resignFirstResponder()
        ConfirmPasswordField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func hideUnhideConPassBtnClicked(_ sender: UIButton) {
   
    
        if(iconClick == true) {
            self.ConfirmPasswordField.isSecureTextEntry = false
        } else {
            self.ConfirmPasswordField.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
    }
    
    
    
    @IBAction func hideTextBtnClicked(_ sender: UIButton) {

        if(iconClick == true) {
            self.PasswordField.isSecureTextEntry = false
        } else {
            self.PasswordField.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
        
        
        
//    self.PasswordField.isSecureTextEntry = false
    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! TypeUserTableViewCell
        cell.userTitle.text = list[indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
     print ("SignUp Screen Reached.")
        self.userTypeTblView.dataSource = self
        self.userTypeTblView.register(UINib(nibName: "TypeUserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        self.userTypeTblView.delegate = self
        self.userTypeTblView.isHidden = true
        
        EmailAddressField.keyboardType = UIKeyboardType.emailAddress
        PasswordField.isSecureTextEntry = true
        ConfirmPasswordField.isSecureTextEntry = true
    
    FirstNameField.delegate = self
        LastNameField.delegate = self
        EmailAddressField.delegate = self
        PasswordField.delegate = self
        ConfirmPasswordField.delegate = self
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        self.view.addSubview(activityIndicator)
    
    
    }
//    @IBOutlet weak var allViews: UIView!
    
    @IBOutlet weak var FirstNameView: UIView!
    

    
    @IBAction func signUpBtnClicked(_ sender: Any) {
   
self.activityIndicator.startAnimating()
        let url = "http://holdthatspace.com/webservices/userSignUp.php"
        self.callSignUpWebService(url: url)
        
    }
    
    
    @IBAction func toSignInBtnClicked(_ sender: Any) {
   
//        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
//
////        vc.uid  = responseJSON["data"]?["userId"] as? String
//        self.navigationController?.pushViewController(vc, animated: true)
self.navigationController?.popViewController(animated: true)
//self.navigationController?.popToRootViewController(animated: true)


    }
    
    
    @IBOutlet weak var LastNameView: UIView!
    
    
    @IBOutlet weak var PasswordField: UITextField!
    
//    @IBOutlet weak var EmailAddressView: UIView!
    @IBOutlet weak var EmailAddressView: UIView!
    
    @IBOutlet weak var ConfirmPasswordView: UIView!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    @IBOutlet weak var PasswordView: UIView!
    

    
    @IBOutlet weak var LastNameField: UITextField!
    
    @IBOutlet weak var FirstNameField: UITextField!
   

    @IBOutlet weak var EmailAddressField: UITextField!
    


    @IBOutlet weak var userTypeTblView: UITableView!
    
    var list = ["seeker", "spotter", "owner"]
//    func numberOFComponenets
    var response1 = String()
    
    
    
    
    @IBOutlet weak var typeUserBtn: UIButton!
    
    
    
    
    
    ///For Drop down List Using Button & TabelView With custom cell
    @IBAction func userTypeBtnClicked(_ sender: Any) {
    
    if self.userTypeTblView.isHidden
    {
        animate(toogle: true)
    }else {
        animate(toogle: false)
        }
    
    
    
    }
    
    
    
    
    ///For Animation of Drop Down List
    func animate(toogle : Bool)
    {
        if toogle{
            UIView.animate(withDuration: 0.3) {
                self.userTypeTblView.isHidden = false
            }
        }else {
            UIView.animate(withDuration: 0.3) {
                self.userTypeTblView.isHidden = true
            }
        }
        
        }
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.typeUserBtn.setTitle("\(list[indexPath.row])", for: .normal)
        animate(toogle: false)
    }
   
    
    
    
    
    
    
    
    func callSignUpWebService(url : String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let firstName  = self.FirstNameField.text
        let lastName = self.LastNameField.text
        let emailId = self.EmailAddressField.text
        let typeUser = self.typeUserBtn.title(for: .normal)
        let password = self.PasswordField.text
//        let json: [String: Any] = ["emailId": "vinay@adixsoft.in",
//                                   "password": "123456"]
//
//        let json: [String: Any] = ["firstName":"efgh",
//                                   "lastName":"fgh",
//                                   "emailId":"shashwat1689@rediffmail.com",
//                                   "userType":"spotter",
//            "password":"1234567"]
        ///Setting Parameters For json Request
        let json: [String: Any] = ["firstName":firstName!,
                                   "lastName":lastName!,
                                   "emailId":emailId!,
                                   "userType":typeUser!,
                                   "password":password!]
        
        
        
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
                    print(responseJSON["code"]!)
                    
                    
                    self.response1 = responseJSON["code"] as! String
                    
                    print(self.response1)
                    
                    //Check response from the sever
                    if self.response1 == "200"
                    {
                        OperationQueue.main.addOperation {
                            self.activityIndicator.stopAnimating()
                            //API call Successful and can perform other operatios
                            print("SignUp Successful")

                            let messageToShow = responseJSON["message"] as! String
                            let alert = UIAlertController(title: "User Registration Successful", message: messageToShow, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                     print("default")
                                    let vc = LoginViewController(nibName: "LoginViewController", bundle : nil)
                                    self.navigationController?.pushViewController(vc, animated: true)
                                   
                                    
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
                            self.activityIndicator.stopAnimating()
                            //API call failed and perform other operations
                            print("SignUp Failed")
                            let messageToShow = responseJSON["message"] as! String
                            let alert = UIAlertController(title: "User Registration Failed", message: messageToShow, preferredStyle: .alert)
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
