import UIKit

class MenuVC: UIViewController{
   
    @IBOutlet weak var saludo: UILabel!
    
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saludo.text = "Hola, \(username)"
        
    }


    
    
}
