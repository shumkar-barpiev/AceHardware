//
//  OrderViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class OrderViewController: UIViewController {
    var user = [User]()
    var userCart = [Cart]()
    var cartProducts = [Product]()
    
    

    @IBOutlet weak var addressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
        
    }
    
    
    
    @IBAction func confirOrderAction(_ sender: Any) {
        
        if !(addressTextField.text?.isEmpty ?? true)!{
            
            let date = Date()
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd.MM.yyyy"
            
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            let dateAndTime = dateFormatter.string(from: currentDate)
            
            
            let orderDateForName = dateFormatter1.string(from: date)
            let orderName = orderDateForName + " Order " + user[0].userName
            var tempTotalSum = 0.0
            
            var orderDescription = "Заказ төмөнкү товарларды камтыйт: \n"
            
            var counter = 1
            
            for product in cartProducts {
                orderDescription = orderDescription + "\t\(counter)) " + product.productName+"\n"
                tempTotalSum += product.price
                counter += 1
            }
            
            orderDescription += "\nТоварлардын жалпы саны: \(cartProducts.count)"
            orderDescription += "\nЗаказдын кетирилген датасы: \(dateAndTime)"
            orderDescription += "\nЖыйынтыктагы сумма: \(tempTotalSum) сом"
            orderDescription += "\nТөлөм тиби: Накталай"
            
            
            let totalSum = "\(tempTotalSum) сом"
            let orderStatus = "Заказ кабыл алынды"
            let phoneNumber = user[0].phoneNumber
            let address = addressTextField.text!
            let customerName = user[0].userName
            let customerId = user[0].id
            
            
            let didSendOrder = sendOrder(orderName, dateAndTime, orderDescription, customerId, customerName, address, phoneNumber, totalSum, orderStatus)
            
            
            if didSendOrder{
                
                for cartProduct in cartProducts {
                    self.deleteFromCart(self.userCart[0].id, cartProduct.id)
                }
                
                let alertController = UIAlertController(title: "Куттуктайбыз, \(user[0].userName)!!!", message: "Сиздин заказыңыз ийгиликтүү кабыл алынды.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                    controller.modalPresentationStyle = .fullScreen
                    controller.user = self.user
                    self.present(controller, animated: false, completion: nil)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            } else{
                let alertController = UIAlertController(title: "Катачылык кетти!!!", message: "Кайра аракет кылып көрүңүз.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                    controller.modalPresentationStyle = .fullScreen
                    controller.user = self.user
                    self.present(controller, animated: false, completion: nil)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
        }else{
            let alerController = UIAlertController(title: "Адрести талаасын толтуруңуз!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
        
    }
    
    
    
   //    MARK: creating new user function
       private func sendOrder(
        _ orderName: String,
        _ orderDate: String,
        _ orderDescription: String,
        _ customerId: Int,
        _ customerName: String,
        _ address: String,
        _ phoneNumber: String,
        _ totalSum: String,
        _ orderStatus: String
        ) -> Bool{
           var sendOrderResponse = true
           
           guard let url = URL(string:"http://localhost/BackendAPIphp/api/ordersAPI.php" ) else{
               return false
           }
           
           var request = URLRequest(url: url)
           
           // method body, headers
           request.httpMethod = "POST"
           
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           let body: [String: AnyHashable] = [
               "orderName": orderName,
               "orderDate": orderDate,
               "orderDescription": orderDescription,
               "customerId": customerId,
               "customerName": customerName,
               "address": address,
               "phoneNumber": phoneNumber,
               "totalSum": totalSum,
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
    
    
    //    MARK:  delete from cart
    public func deleteFromCart(_ cartID: Int, _ productID: Int){
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerCartAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cartId": cartID,
            "productId": productID
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
                print("something wrong")
            }
        }
        
        task.resume()
    }
    
    

}
