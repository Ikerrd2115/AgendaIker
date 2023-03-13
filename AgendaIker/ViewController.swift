import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var passUser: UITextField!

    
    var listaUser : [String] = []
    var listaPass : [String] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "IdIniciarSesion"{
            let destinationVC = segue.destination as? MenuVC
            
            destinationVC?.username = nameUser.text!
            
            
        }
        
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
    
    let dataManager : DataManager = DataManager()
    let url = URL(string: "https://superapi.netlify.app/api/db/users")
    func loadUsers(){
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200, error == nil else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.dataManager.login.removeAll()
                for user in json as! [[String : Any]] {
                    self.dataManager.login.append(Login(json: user))
                    
                }
                for pass in json as! [[String : Any]] {
                    self.dataManager.login.append(Login(json: pass))
                    
                }
                self.listaUser.removeAll()
                for userLog in self.dataManager.login{
                    self.listaUser.append(userLog.user)
                    self.listaPass.append(userLog.pass)
                    
                }
                
            } catch let errorJson {
                print(errorJson)
            }
        }.resume()
    }
    
    
    @IBAction func inicarSesion(_ sender: Any) {
        print(listaUser)
        print(listaPass)
        for i in 1...listaUser.count{
            if listaUser[i-1] == nameUser.text && listaPass[i-1] == passUser.text{
                print("match")
                performSegue(withIdentifier: "IdIniciarSesion", sender: (Any).self)
                break
            }
            else{
                print("error")
            }
        }
        self.showToast(message: "Revisa los datos", font: .systemFont(ofSize: 12.0))
        print("Revisa los datos")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
}








