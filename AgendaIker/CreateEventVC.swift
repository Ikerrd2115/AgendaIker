import UIKit

class CreateEventViewController: UIViewController {
    let dataManager : DataManager = DataManager()
    
   
    @IBOutlet weak var crearEvento: UITextField!
    
    @IBOutlet weak var dateFecha: UIDatePicker!
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    @IBAction func botonSubir(_ sender: Any) {
        if crearEvento.text!.count > 0 {
        
        let newEvent : String = crearEvento.text!
        let newDate = Int(dateFecha.date.timeIntervalSince1970 * 1000)
        
        
        let url = URL(string: "https://superapi.netlify.app/api/db/eventos")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postEvent: [String : Any] = [
            "date" : newDate,
            "name" : newEvent
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postEvent, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
          
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Events>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
            performSegue(withIdentifier: "volverAlMenu", sender: (Any).self)
        }
        
        else{
            self.showToast(message: "Nombre vacio", font: .systemFont(ofSize: 12.0))
        }
        
    }
    
}
