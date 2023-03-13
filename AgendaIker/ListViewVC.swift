import Foundation
import UIKit

class ViewControllerListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    let dataManager : DataManager = DataManager()
    let url = URL(string: "https://superapi.netlify.app/api/db/eventos")
    func loadEvents(){
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200, error == nil else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.dataManager.events.removeAll()
                for name in json as! [[String : Any]] {
                    self.dataManager.events.append(Events(json: name))
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } catch let errorJson {
                print(errorJson)
            }
            
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadEvents()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.events.count
    }
    
    @IBAction func dismisBoton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventRow: EventsRow = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsRow
        let eventss = dataManager.events[indexPath.row]
        let newTime = TimeInterval(dataManager.events[indexPath.row].date / 1000)
        let newDate = Date(timeIntervalSince1970: newTime)
        
        eventRow.name.text = eventss.name
        eventRow.date.text = newDate.formatted().description
        
        return eventRow
    }
    
   
}
