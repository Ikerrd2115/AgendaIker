class Login : Codable{
    public let user: String
    public let pass: String
    
    init(json: [String: Any]) {
        user = json["user"] as? String ?? ""
        pass = json["pass"] as? String ?? ""
    }
}

