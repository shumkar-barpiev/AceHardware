//
//  OrderStatusViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class OrderStatusViewController: UIViewController {

    var order = [Order]()
    
    
    @IBOutlet weak var orderStatusTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(order)
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminOrderNavViewController") as! AdminOrderNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        
    }
    
    @IBAction func updateOrderStatusAction(_ sender: Any) {
        if !(orderStatusTextField.text?.isEmpty ?? true)!{
            
            let orderId = order[0].orderId
            let orderStatus = orderStatusTextField.text!
            
            let didUpdate = updateOrderStatus(orderId, orderStatus)
            
            
            if didUpdate{
                
                let alertController = UIAlertController(title: "Заказдын статусу ийгиликтүү жаңыртылды!!!", message:"", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AdminOrderNavViewController") as! AdminOrderNavViewController
                    
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            } else{
                let alertController = UIAlertController(title: "Катачылык кетти!!!", message: "Кайра аракет кылып көрүңүз.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
            
        }else{
            let alerController = UIAlertController(title: "Текст талаасына маани киргизиниз!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
            
        }
    }
    
    
    
   //    MARK: updating order status function
       private func updateOrderStatus(
        _ orderId: Int,
        _ orderStatus: String
        ) -> Bool{
           var sendOrderResponse = true
           
           guard let url = URL(string:"http://localhost/BackendAPIphp/api/orderStatusUpdateAPI.php" ) else{
               return false
           }
           
           var request = URLRequest(url: url)
           
           // method body, headers
           request.httpMethod = "POST"
           
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           let body: [String: AnyHashable] = [
               "orderId": orderId,
               "orderStatus": orderStatus
           ]
           request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
           
           //make request
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else{
                   return
               }
               // Convert HTTP Response Data to a String
               if let dataString = String(data: data, encoding: .utf8) {
                   print("Response data string:\n \(dataString)")
               }else{
                   sendOrderResponse = false
               }
           }
           task.resume()
           
           return sendOrderResponse
       }
}
