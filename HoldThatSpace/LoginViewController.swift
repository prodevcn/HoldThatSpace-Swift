//
//  LoginViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
   
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    @IBOutlet weak var passwordView: UIView!
    let facebookLogin = LoginManager()

    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var outerStackView: UIStackView!
    
    @IBOutlet weak var outerTopLayout: NSLayoutConstraint!
   


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   print ("reached login screen do login in this screen .")
        

    userNameField.delegate = self
        passWordField.delegate = self
       userNameField.keyboardType = UIKeyboardType.emailAddress
         passWordField.isSecureTextEntry = true
//        self.response = "1"
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
activityIndicator.isHidden = true 
        print ("The access token for current session : \(String(describing: AccessToken.current))")
        if (AccessToken.current != nil) {
           print ("Already Logged In With Facebook")
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        passWordField.resignFirstResponder()
        return true
    }
    
 

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
    }
    
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
    //Facebook SignIn Integration
    @IBAction func fbBtnClicked(_ sender: FBLoginButton) {
     
 
        
        self.facebookLogin.logIn(permissions: ["email"], from: self) { (result, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                print ("user:",user)
                let url = "http://holdthatspace.com/webservices/userSocialSignup.php"
                self.callSocialLoginWebservice(url: url)
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()

                // self.performSegue(withIdentifier: self.signInSegue, sender: nil)
            }
        }
        
    
    
    
    
    }
                        
    
    





    
    
    
    @IBOutlet weak var gSignInButton: GIDSignInButton!
    
    

    @IBAction func loginBtnClicked(_ sender: Any) {

      let url = "http://holdthatspace.com/webservices/userSignIn.php"
       self.callLoginWebservice(url : url)
          self.view.addSubview(activityIndicator)
 activityIndicator.startAnimating()

    }
    
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        // When user is signed in
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error:", error.localizedDescription)
                return
            }
        })
        
        print ("userId:", user.userID!)
         self.gUserId = user.userID!
        let gUserEmail = user.profile!
        print ("The gUserEmail:\(gUserEmail)")
        print ("The gUserId :\(gUserId)")
        let url = "http://holdthatspace.com/webservices/userSocialSignup.php"
        self.callSocialLoginWebservice(url: url)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        }
    var gUserId : String!

    @IBOutlet weak var userNameField: UITextField!
    
    
    @IBOutlet weak var passWordField: UITextField!
    
    var response1 : String!
    

    @IBAction func gSignInbtnClicked(_ sender: GIDSignInButton!) {
    
    GIDSignIn.sharedInstance().signIn()
    
    
    
    
    }
    
    
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {


        let vc = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    var usertype = String()
 var userId = String()
 func callLoginWebservice(url : String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let userName = self.userNameField.text
        let passWord = self.passWordField.text
        let json  = ["emailId": userName!,
                                   "password": passWord!]
        print ("The JSON for post request: \(json)  ")
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
                    
         

                    self.response1 = responseJSON["code"] as? String

                    print(self.response1!)

                    //Check response from the sever
                    if self.response1 == "200"
                    {
                        OperationQueue.main.addOperation {
             self.activityIndicator.stopAnimating()
                            //API call Successful and can perform other operatios
                            print("Login Successful")
                            self.userId = (responseJSON["data"]!["userId"] as? String)!
                            print ("The unique userId after loging :\(self.userId)")
let userType = (responseJSON["data"]!["userType"] as? String )!
                            let emailId = (responseJSON["data"]!["emailId"] as? String )!

                            let status = (responseJSON["isSuccess"]! as! String)
                            print ("The user credentials are now stored in UserDefault with emailId \(emailId) and user of type \(userType) after getting status \(status)")
                            UserDefaults.standard.set(emailId, forKey: "emailId")
                            UserDefaults.standard.set(userType, forKey: "userType")
                            UserDefaults.standard.set(status, forKey: "isSuccess")
                            if responseJSON["data"]?["userType"] as! String == "spotter" {
                                self.usertype = "spooter"
//                                UserDefaults.standard.set(self.usertype, forKey: "userType" )
                            let vc = RecentSpaceViewController(nibName: "RecentSpaceViewController", bundle: nil)
//                            = responseJSON["data"] as? String
                          vc.uid  =  self.userId
                         self.navigationController?.pushViewController(vc, animated: true)
                                
                            
                            
                            
                        }
                            else{
                                
                                
                                
                                self.usertype = "seeker"
  UserDefaults.standard.set(self.usertype, forKey: "userType" )
                                let vc = AvailableSpaceViewController(nibName: "AvailableSpaceViewController", bundle: nil)
                                vc.uid = responseJSON["data"]?["userId"] as? String
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                                
                                
                            }
                        }

                    }

                    else
                    {
                        OperationQueue.main.addOperation {
                             self.activityIndicator.stopAnimating()
                            //API call failed and perform other operations
                            print("Login Failed")

                            let alert = UIAlertController(title: "Login Failed", message: "Enter Correct User Details Or SignUp ", preferredStyle: .alert)
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
                print("Error  in data from server -> \(error)")
            }



        }


        task.resume()

    }

    
    
    
    func callSocialLoginWebservice(url: String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        
//        let deviceID = UIDevice.current.identifierForVendor!.uuidString
//        print("the device Id of this device ",deviceID)
        let json = ["firstName":"social firstname",
            "lastName":"test lastname",
            "userType":"vendor",
            "fbTwitterId":self.gUserId,
            "deviceType":"iphone",
            "deviceToken":"token12345"]
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
                    //                    print(responseJSON["data"]?["userId"]!! as Any )
                    
                    
                    //                    print("userType:",responseJSON["data"]?["userType"] as! String)
                    self.response1 = responseJSON["code"] as? String
                    
                    print(self.response1!)
                    
                    //Check response from the sever
                    if self.response1 == "200"
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call Successful and can perform other operatios
                            print("Login Successful")
                            self.activityIndicator.stopAnimating()
                            if responseJSON["data"]?["userType"] as! String == "spotter" {
                                let vc = RecentSpaceViewController(nibName: "RecentSpaceViewController", bundle: nil)
                                //                            = responseJSON["data"] as? String
                                vc.uid  = responseJSON["data"]?["userId"] as? String
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                                
                                
                            }
                            else{
                                
                                
                                let vc = AvailableSpaceViewController(nibName: "AvailableSpaceViewController", bundle: nil)
                                let uid : String = responseJSON["data"]?["userId"] as! String 
                                vc.uid = responseJSON["data"]?["userId"] as? String
                                print ("The userId of seeker :\(uid)")
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                                
                                
                            }
                        }
                        
                    }
                        
                    else
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call failed and perform other operations
                            print("Login Failed")
                            self.activityIndicator.stopAnimating()
                            let alert = UIAlertController(title: "Login Failed", message: "Enter Correct User Details Or SignUp ", preferredStyle: .alert)
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
    
    
    
    
    
    

