//
//  RecentSpaceViewController.swift
//  HoldThatSpace
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RecentSpaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    var uid : String?
  // Appending Values from The Api
    var arr = [AnyObject]()
    var spacedescription = [AnyObject]()
    var spaceprice = [AnyObject]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.arr.count
        
        print (rows)

   return rows
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
       
        let verticalPadding: CGFloat = 8
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         recentSpaceTbl.register(UINib(nibName: "RecentSpaceTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentSpaceTableViewCell
        
        
        

        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        
        cell.clipsToBounds = true
        let text = self.arr[indexPath.row]
        let descriptionText = self.spacedescription[indexPath.row]
        let priceText = self.spaceprice[indexPath.row]
        cell.titleLbl!.text = text as? String
    
        cell.descriptionLbl!.text = descriptionText as? String
        cell.priceLbl!.text = priceText as? String
        
        
        return cell
        
        
        
    }
    
    
    
    
    
    @IBAction func bckBtnclicked(_ sender: Any) {
    
self.navigationController?.popViewController(animated: true)
    
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This Screen Is to show all recent spaces of Spotter with userId :\(self.uid!)")

        // Do any additional setup after loading the view.
   
  
      
      recentSpaceTbl.dataSource = self
       recentSpaceTbl.delegate = self
        
        print("uid:",uid!)
        
        let url = "http://holdthatspace.com/webservices/spotterSpace.php"
        self.callSpotterRecentSpace(url : url)

        
    
    }


    
    @IBOutlet weak var recentSpaceTbl: UITableView!
    var response1 : String!
//    var data : [AnyObject]?
    
    func callSpotterRecentSpace(url : String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
//        let userName = self.userNameField.text
//        let passWord = self.passWordField.text
//        let uid = self.uid
        let json: [String: Any] = ["userId": self.uid]
//        let json: [String: Any] = ["userId": "1"]
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
                    
                    print("server code:",self.response1!)
                    
                
                     let space = responseJSON["data"] as? [[String:AnyObject]]
                    //Check response from the sever
                    if self.response1 == "200"
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call Successful and can perform other operatios
                            print("List OF Space From Spotter Successful")
                            if space != nil {
                                
                                
                                print ("Server Data of Space Listed by spotter:",responseJSON["data"])
                               
                for spaceDict in space! {
                        let  titl = spaceDict["sId"]
                let descr = spaceDict["spaceTitle"]
            let pric = spaceDict["spacePrice"]
            print("title: \(String(describing: titl!))")
        self.arr.append(String(describing: titl!) as AnyObject)
                                                                self.spacedescription.append(String(describing: descr!) as AnyObject)
                                                                self.spaceprice.append(String(describing: pric!) as AnyObject )
                                                                print("spacedescription:" , self.spacedescription)
                                                                print ("spacetitle:",self.arr)
                                                                print ("spaceprice:", self.spaceprice)
                                
                                
                                
                                
                            }
                            print("Spotter Recent Space List Found")
                            
                            self.recentSpaceTbl.reloadData()
                            }
                            
                            
                            
                            
                            else{
                              
                                
self.showSimpleActionSheet(controller: self)
//
//
//                                let vc = ListSpaceViewController(nibName: "ListSpaceViewController", bundle: nil)
//                                print ("TheUserId:", self.uid )
//                                vc.uid = self.uid
//                                self.navigationController?.pushViewController(vc, animated: true)
//
//
                                
                                
                            }
                        }
                        
                     
                        
                        
                    }
                        
                    else
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call failed and perform other operations
                             print("Spotter Recent space list not found ")
                            self.recentSpaceTbl.reloadData()
                            
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

    
    override func viewWillAppear(_ animated: Bool) {
        showSimpleActionSheet(controller: self)
    }
    
    
    //Simple Action Sheet For Checking If The Spotter Have any previous space and if it's not the it can list a space
    
    
    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "You Don't Have Listed Any Space Yet!", message: " Please Select an Option to List Your Space", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "List A Space ", style: .default, handler: { (_) in
            print("User click Approve button")
//            let vc = ListSpaceViewController(nibName: "ListSpaceViewController", bundle: nil)
//            vc.uid = self.uid!
            let vc = ListYourSpaceViewController(nibName:"ListYourSpaceViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
