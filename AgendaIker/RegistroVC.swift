import UIKit

class ViewControllerRegistro: UIViewController{
    let dataManager : DataManager = DataManager()
    
    
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    @IBAction func Registrarse(_ sender: Any) {
        
        let nomUsuarioTexto : String = nomUsuario.text!
        let passUsuarioTexto : String = passUsuario.text!
        
        
        let url = URL(string: "https://superapi.netlify.app/api/db/users")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postUser: [String : Any] = [
            "user" : nomUsuarioTexto,
            "pass" : passUsuarioTexto
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postUser, options: .prettyPrinted)
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
                let responseObject = try JSONDecoder().decode(ResponseObject<Login>.self, from: data)
                print(responseObject)
            } catch {
                print(error)
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        task.resume()
        performSegue(withIdentifier: "idAIniciarSesion", sender: (Any).self)
        
    }
    
    @IBOutlet weak var nomUsuario: UITextField!
    
    @IBOutlet weak var passUsuario: UITextField!
    

    
    
    
}
