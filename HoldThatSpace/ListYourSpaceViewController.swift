//
//  ListYourSpaceViewController.swift
//  HoldTheSpace
//
//  Created by Mac on 5/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

class ListYourSpaceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var sptitle : [String] = ["Title 1","Title2","Title3","Title4"]
    var vehicle : [String] = ["Vehicle1", "Vehicle2", "Vehicle3", "Vehicle4"]
    var price : [String] = ["Free", "2$", "4$","5$"]
    var alert : [String] = ["Nearby Gas Station", "Nearby Restaurent","Nearby ATM", "Nearby Park"]
   
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   print ("This Screen is for listing a space")
  self.vehicleDropDown.isHidden = true
        self.titleDropDow.isHidden = true
        self.priceDropDown.isHidden = true
        self.alertDropDown.isHidden = true
        
        self.vehicleDropDownHC.constant = 0.0
        self.titleDropDownHC.constant = 0.0
   self.pricedropDownHC.constant = 0.0
        self.alertDropDownHC.constant = 0.0
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
 activityIndicator.isHidden = true

    }
    @IBOutlet weak var deatlsFld: UITextField!
    @IBOutlet weak var addressFld: UITextField!
    @IBOutlet weak var landmarkFld: UITextField!
    @IBAction func imageUploadBtnClicked(_ sender: Any) {
     
     self.settypeImagePicker()
    
    }
    func imageUploadRequest( image: UIImage, uploadUrl: NSURL, param: [String:String]?) {
        
        let request = NSMutableURLRequest(url:uploadUrl as URL);
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        let imageData = self.productImage.pngData()
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "sImage", imageDataKey: imageData! as NSData, boundary: boundary) as Data
   
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
                                                  
                                                    OperationQueue.main.addOperation{
                                                        self.activityIndicator.stopAnimating()
                                                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                        print("****** response data = \(responseString!)")
                                                        let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                                                        
                                                        print("json value \(json)")
                        let vc = RecentSpaceViewController(nibName :"", bundle:nil)
                            vc.uid = "22"
                                self.navigationController?.pushViewController(vc, animated: true)
                                                    }
                                                
                                                    
                                                 
                                                    
                                                    
                                                    
                                                } else if let error = error {
                                                    OperationQueue.main.addOperation{
                                                        self.activityIndicator.stopAnimating()
                                                        
                                                    }
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
        
        let filename = "space_image.jpg"
        
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
    var uid : String! = ""
    
    @IBAction func submitSpaceBtnClicked(_ sender: Any) {
    
//
//        let parameters = [    "userId":"37",
//                              "stId":"2",
//                              "vtId":"3",
//                              "sAddress":"address",
//                              "sLandmark":"landmark",
//                              "stmId":"4",
//                              "spId":"5","sDetail":"This is the best space for your vehicles . Hit the HTS BUTTON to Hold this space as soon as possible ","salert":"Nearby Gas Station"]
//
        
        
        
        
        
       let parameters =  ["userId": "21" ,
        "stId" : "1",   // space title ID
        "vtId" :   "2",// vehicle type ID
        "sAddress" : "123 Nyc Street , Rouston Tower, 32 gr floor ",
        "sLandmark" : "Green Cars Are Now Faster.",
        "stmId": "2" ,   // space time ID
        "spId" : "3" ,   // space price ID
        "hsnId" :"2" , // nearby ID
        "sDetails":"This to just create a parking space for user "]
        let uRL = URL(string:"http://holdthatspace.com/webservices/listSpace_two.php")!
        self.view.addSubview(self.activityIndicator)
        activityIndicator.startAnimating()
        self.imageUploadRequest(image: self.productImage,uploadUrl: uRL as NSURL, param: parameters)
    
    
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addressFld.resignFirstResponder()
        self.landmarkFld.resignFirstResponder()
        self.deatlsFld.resignFirstResponder()
        self.titleFld.resignFirstResponder()
        self.priceFld.resignFirstResponder()
        self.vehicleFld.resignFirstResponder()
        return true
    }
    @IBAction func bckBtnClicked(_ sender: Any) {
        
        
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imageUploadBtn: UIButton!
    @IBOutlet weak var alertDropDownHC: NSLayoutConstraint!
    @IBOutlet weak var alertDropDown: UIPickerView!
    @IBOutlet weak var alertFld: UITextField!
    @IBOutlet weak var titleFld: UITextField!
    
    @IBOutlet weak var vehicleDropDownHC: NSLayoutConstraint!
    @IBOutlet weak var titleDropDow: UIPickerView!
    @IBOutlet weak var titleDropDownHC: NSLayoutConstraint!
    
    @IBOutlet weak var vehicleFld: UITextField!
    
    @IBOutlet weak var vehicleDropDown: UIPickerView!

    @IBOutlet weak var priceFld: UITextField!
    
    
    @IBOutlet weak var priceDropDown: UIPickerView!
    
    
    @IBOutlet weak var pricedropDownHC: NSLayoutConstraint!
    
    
    var imagePicker = UIImagePickerController()
    var productImage = UIImage()
    func settypeImagePicker()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.activityIndicator.stopAnimating()
            self.present(imagePicker , animated : true , completion : nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            //            imageToShow.image = image
            self.productImage = image
            
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print("Local_path_photo:",photoURL)
            
        }
        
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rowCount : Int = sptitle.count
        
        if pickerView == vehicleDropDown {
        rowCount = self.vehicle.count
        return rowCount
        }else if pickerView == priceDropDown{
            rowCount = self.price.count
            return rowCount
        }
        else if pickerView == alertDropDown{
            rowCount = self.alert.count
        }
        return rowCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == titleDropDow{
            let titleRow = sptitle[row]
            
       return titleRow
        }
        else if pickerView == vehicleDropDown   {
            let vehicleRow = vehicle[row]
            return vehicleRow
        }else if pickerView == priceDropDown{
            let priceRow = price[row]
            return priceRow
        }
        else if pickerView == alertDropDown{
            let alertRow = alert[row]
            return alertRow
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == titleDropDow{
            self.titleFld.text = self.sptitle[row]
    self.titleDropDow.isHidden = true
            self.titleDropDownHC.constant = 0.0
        }
        else if pickerView == vehicleDropDown{
            self.vehicleFld.text = self.vehicle[row]
            self.vehicleDropDown.isHidden = true
            self.vehicleDropDownHC.constant = 0.0
            
        }
        else if pickerView == priceDropDown{
            self.priceFld.text = self.price[row]
            self.pricedropDownHC.constant = 0.0
            self.priceDropDown.isHidden = true
        }
        else if pickerView == alertDropDown{
            self.alertFld.text = self.alert[row]
            self.alertDropDown.isHidden = true
            self.alertDropDownHC.constant = 0.0
        }
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == titleFld){
            
           self.titleDropDow.isHidden = false
            self.titleDropDownHC.constant = 90.0

        }else if (textField == vehicleFld){
         self.vehicleDropDown.isHidden = false
        self.vehicleDropDownHC.constant = 90.0

        }
        else if (textField == priceFld){
            self.priceDropDown.isHidden = false
            self.pricedropDownHC.constant = 90.0
        }
    
        else if (textField == alertFld){
            self.alertDropDown.isHidden = false
            self.alertDropDownHC.constant = 90.0
        }
    
    }


}
