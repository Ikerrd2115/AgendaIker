class Events : Codable{
    public let name: String
    public let date: Double
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        date = json["date"] as? Double ?? 0
    }
}
