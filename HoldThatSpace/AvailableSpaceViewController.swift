//
//  AvailableSpaceViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/16/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit






class AvailableSpaceViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, SpaceDelegate, PayPalPaymentDelegate  {
    
    
     let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
var uid : String?
    var titleArray = ["title1", "title2", "title3", "title4", "title5", "title6"]
    var titlePrice = ["Free", "2$","5$","7$","10$","15$","20$","25$"]
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController)
    {
        print ("PayPal Payment cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func LogoutBtnClicked(_ sender: Any) {
        print ("Logout Button Clicked ")
        
//        UserDefaults.standard.set("false", forKey: "isSuccess")
//        UserDefaults.standard.setNilValueForKey("isSuccess")

       

        let refreshAlert = UIAlertController(title: "SIGN-OUT", message: "ARE YOU SURE TO SIGNOUT?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            self.menuPopOver.removeFromSuperview()
             UserDefaults.standard.set("false", forKey: "isSuccess")
            print("Handle Ok logic here")
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    
    
    }
    var userId = ""
    var sPrice : String!
    var sTitle : String!
    func payPalPaymentViewController (_ paymentViewController : PayPalPaymentViewController, didComplete completedPayment : PayPalPayment)
    {
        print ("payPal payment Success")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            
            print ("paymentInfo:", completedPayment.confirmation)
            let paymentDetails  = completedPayment.paymentDetails!
           print ("ThePaymentDetail\(paymentDetails)")
            let description = completedPayment.description
            print ("The ShortDescription of your payment \(description)")
//            let transactionId = response["id"]
           
             let dic = completedPayment.confirmation as? [String:Any]
            let loginDic = dic?["response"] as? [String:Any]
            
            self.userId = loginDic?["id"] as! String
                print ("the id of transaction is :", self.userId)
            
            
            
       
            
            print ("The TransactionId \(self.userId) is processed sucessfully ")
            let url = "http://holdthatspace.com/webservices/seekerBooking.php"
            self.completedPaymentWebservice (url: url)

            
            
            
        })
    
        
        
    }
    
        var sucessString : Int!
    
    
    func completedPaymentWebservice (url : String )
    {
       
    
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let userTransactionId : String = self.userId
    let userId = self.uid
        let json = ["userId": userId,
        "sId":"5",
        "transactionId": userTransactionId]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]{
                    print("responseFromWebService : \(responseJSON)")
                    print(responseJSON["code"] as Any)
                    
                    

                    let livingArea = responseJSON["code"] as? Int ?? 200
                    //Check response from the sever
                    if livingArea == 200 {
                        OperationQueue.main.addOperation {
                            
                            //API call Successful and can perform other operatios
                            print("Payment Upadted On The Server ")
                            
                            let svc = TheSpaceDetailsViewController(nibName: "TheSpaceDetailsViewController", bundle : nil)
                            self.navigationController?.pushViewController(svc, animated: true )
                            
                        }
                        
                        
                    }
                        
                    else
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call failed and perform other operations
                            print("Payment Updation Failed")
                            
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
    
    
        
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var ssTitle : String!
    func paymentForSpace(sprice: String, sTitle : String ) {
        print("paymentProcessStarted")
        self.ssTitle = sTitle
        self.sPrice = sprice
        print ("The selected space Price is : \(String(describing: self.sPrice))")
        if sprice == "Free"{
            self.sPrice = "0"
            let alert = UIAlertController(title: "Space Price", message: "The Space You Have Selected is Free To Hold  ", preferredStyle: .alert)
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
        
    let CheckVC = CheckoutViewController()
        CheckVC.sTitle = sTitle
        CheckVC.sPrice = sprice
        present(CheckVC, animated: true, completion:nil)
//        let item1 = PayPalItem(name: self.ssTitle, withQuantity: 1, withPrice: NSDecimalNumber(string: self.sPrice), withCurrency: "USD", withSku: "Hip-0037")
////        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
////        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
//        let items = [item1]
//        let subtotal = PayPalItem.totalPrice(forItems: items) //This is the total price of all the items
//        // Optional: include payment details
//        let shipping = NSDecimalNumber(string: "0.00")
//        let tax = NSDecimalNumber(string: "0.00")
//        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//        let total = subtotal.adding(shipping).adding(tax) //This is the total price including shipping and tax
//        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "AdixSoft", intent: .sale)
//        payment.items = items
//        payment.paymentDetails = paymentDetails
//        if (payment.processable) {
//            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//            present(paymentViewController!, animated: true, completion: nil)
//        }
//        else {
//            // This particular payment will always be processable. If, for
//            // example, the amount was negative or the shortDescription was
//            // empty, this payment wouldn’t be processable, and you’d want
//            // to handle that here.
//            print("Payment not processalbe: (payment)")
//        }
        
        
        
        
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.titleArray.count


        
    }
    
    
    @IBAction func userProfileBtnClicked(_ sender: Any) {
    self.menuPopOver.removeFromSuperview()
        let vc = ProfileViewController(nibName : "ProfileViewController", bundle : nil)
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    var arr = [AnyObject]()
//    var spacedescription = [AnyObject]()
    var spaceprice = [AnyObject]()
    
    
    @IBAction func menuBtnClicked(_ sender: Any) {
//        let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
        
        self.view.addSubview(menuPopOver)
        menuPopOver.frame = CGRect(x: 250, y: 26, width: 250, height: 150)
        
        
        
    }
    @IBOutlet weak var MenubtnClicked: UIButton!
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpaceTableViewCell
//        let text = self.arr[indexPath.row]
////        let descriptionText = self.spacedescription[indexPath.row]
//        let priceText = self.spaceprice[indexPath.row]
//        cell.spaceTitleLbl.text = text as? String
//        cell.priceLbl.text = priceText as? String
        
        
        cell.spaceTitleLbl.text = self.titleArray[indexPath.row]
        cell.priceLbl.text = self.titlePrice[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
        var payPalConfig = PayPalConfiguration()
    override func viewDidAppear(_ animated: Bool) {
        self.menuPopOver.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//    print("Available Space in Your Area is shown in this screen .As you are seeker choose the best near by space in your area userid:",self.uid!)
    
    self.spaceTableView.dataSource = self
        self.spaceTableView.register(UINib(nibName: "SpaceTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.spaceTableView.delegate = self 
    self.menuPopOver.layer.cornerRadius = 15
        _ = "http://holdthatspace.com/webservices/availableSpace.php"
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
//        activityIndicator.isHidden = true
//        callAvailableSpaceWebservice(url: url )
//
        self.activityIndicator.isHidden = true
        self.view.addSubview(self.activityIndicator)
//        self.activityIndicator.startAnimating()
   
    //PayPal Integration
        payPalConfig.acceptCreditCards = false
        let name = "Adixsoft"
        payPalConfig.merchantName = name
        let merchantPPurl =  URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full ")
        let merchantUserurl = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        //             let url = URL(string: "http://holdthatspace.com/webservices/listSpace_two.php")!
        payPalConfig.merchantPrivacyPolicyURL = merchantPPurl
        payPalConfig.merchantUserAgreementURL = merchantUserurl
        //This is the language in which your paypal sdk will be shown to users.
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        //Here you can set the shipping address. You can choose either the address associated with PayPal account or different address. We’ll use .both here.
        payPalConfig.payPalShippingAddressOption = .both;
        
        
    
    
    }

    @IBOutlet weak var spaceTableView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get text in label nameLabel
        let selectedCell = tableView.cellForRow(at: indexPath) as! SpaceTableViewCell
        
        // here is the text of the label
        let sPPrice = selectedCell.priceLbl.text
        self.sPrice = sPPrice
        let vc = TheSpaceDetailsViewController(nibName: "TheSpaceDetailsViewController", bundle: nil)
//
//        present(vc, animated: true, completion: nil)
//        vc.uID = self.uid!
        vc.uID = self.uid!
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: nil)
        self.menuPopOver.removeFromSuperview()
self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func aboutBtnClicked(_ sender: Any) {
       self.menuPopOver.removeFromSuperview()
        let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
//        present(vc, animated: true, completion: nil)
self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func contactUsBtnClicked(_ sender: Any) {
         self.menuPopOver.removeFromSuperview()
        let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//        present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    
    
    @IBOutlet var menuPopOver: UIView!
    
    
    
    var response1 : String!
    
    
    func callAvailableSpaceWebservice(url: String )
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
//        let userName = self.userNameField.text
//        let passWord = self.passWordField.text
        let userid   = self.uid!
        let json = ["userId":  userid,
                                  "sAddress":"address"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        self.activityIndicator.startAnimating()
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
                                vc.uid = responseJSON["data"]?["userId"] as? String
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
