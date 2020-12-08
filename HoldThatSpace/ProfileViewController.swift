//
//  ProfileViewController.swift
//  HoldTheSpace
//
//  Created by Shashwat Prakash   on 28/04/19.(03-05-2019(FRIDAY 1:11 AM-5:00 PM ) FRESH WORK WITHOUT POD INSTALLLED AND WANT TO ATTACH GOOGLE SIGN-IN AND FACEBOOK SIGN-IN AND PAYPAL-BINARYTREE INTEGRATION WITH FIREBASE AUTHENTICATION AND UPLOADING SPACE_IMAGE AND UPDATE PROFILE_IMAGE ASLO START GIVING WRAPPER CLASSES TO THE HTS WORK.   )

// RIGHT NOW STARING WITH USERPROFILE CLASS AND UPDATING IMAGE TO THE FTP SERVER OF PORTDEMO.LETS TRY ! THE SERVER SIDE CODE IS IN .PHP ....
//  Copyright © 2019 Mac. All rights reserved.
//

//
//  ProfileViewController.swift
//  HoldTheSpace
//
//  Created by Shashwat Prakash   on 28/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import MobileCoreServices



//extension NSMutableData {
//
//    func appendString(string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        append(data!)
//    }
//}
//




class ProfileViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    var imagePicker = UIImagePickerController()
      var pickedImageProduct = UIImage()
    var response1 : String?
    var firstName : String?
    var lastName : String?
    var emailId : String?
    var uID : String?
    var profileImageString  : String?
   
    @IBOutlet var menuPopOver: UIView!
    
    @IBAction func contactHTSBtnClicked(_ sender: Any) {
    
        
        self.menuPopOver.removeFromSuperview()
        let vc = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//        self.present(vc, animated: true, completion: nil)
self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func userProfileBtnClicked(_ sender: Any) {
   
    
    self.menuPopOver.removeFromSuperview()
  
    
    
    }
    
    
    @IBAction func aboutHTSBtnClcked(_ sender: Any) {
    
    self.menuPopOver.removeFromSuperview()
        let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("This is the profile screen of User .")
        

        
        
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderWidth = 1.5
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
        
        descriptionLbl.text = "This is the description of the User . It contains the Name & Email Address .It Also provide the option to change the profile image of the user."
        // Do any additional setup after loading the view.
        
        self.menuPopOver.layer.cornerRadius = 15
        
        
        
    }

    
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func editBtnClicked(_ sender: Any) {
        
        self.settypeImagePicker()
        
        
        
        
        
    }
    

   
    
    @IBOutlet weak var descriptionLbl: UILabel!
    

    @IBOutlet weak var nameLbl: UILabel!
    

    @IBOutlet weak var emailLbl: UILabel!
    


    @IBAction func bckBtnclicked(_ sender: Any) {
   
    
//    dismiss(animated: true, completion: nil)
self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func menuPopOverbtnClicked(_ sender: Any) {
    
        self.view.addSubview(menuPopOver)
        
        menuPopOver.frame = CGRect(x: 250, y: 26, width: 250, height: 200)
    
    
    }
    
    
    
    func settypeImagePicker()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker , animated : true , completion : nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

       
        
        let image = info[.originalImage] as! UIImage
        
        self.profileImage.image = image
            
//            let parameters = [
//                "userId":"1",
//                "stId":"2",
//                "vtId":"3",
//                "sAddress":"address",
//                "sLandmark":"landmark",
//                "stmId":"4",
//                "spId":"5"]

           let parameters = ["userId":"1",
            "firstName":"vi",
            "lastName":"nay",
            "emailId":"demoadix@gmail.com"]

            let url = URL(string: "http://holdthatspace.com/webservices/listSpace_two.php")!
            
            
            self.imageUploadRequest( image: self.pickedImageProduct, uploadUrl: url as NSURL, param: parameters)

        
         picker.dismiss(animated: true)
        
    }

    
    //Image Upload To PHP Server For FTP
    
    func imageUploadRequest( image: UIImage, uploadUrl: NSURL, param: [String:String]?) {
        
        let request = NSMutableURLRequest(url:uploadUrl as URL);
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        let imageData = pickedImageProduct.pngData()
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "userImage", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest,
                                               completionHandler: {
                                                (data, response, error) -> Void in
                                                if let data = data {
                                                    
                                                    // You can print out response object
                                                    print("******* response = \(response)")
                                                    
                                                    print(data.count)
                                                    // you can use data here
                                                    
                                                    // Print out reponse body
                                                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                    print("****** response data = \(responseString!)")
                                                    
                                                    let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                                                    
                                                    print("json value \(json)")
                                                    
                                                    //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                                                    
                                                    
                                                    
                                                } else if let error = error {
                                                    print(error)
                                                }
        })
        task.resume()
        
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "space-image.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
}
