enum CardAPIs {
    case getCardLists
}

extension CardAPIs: TargetType {
    var baseURL: URL {
        return URL(string: "https://run.mocky.io/v3")!
    }
    
    var path: String {
        switch self {
        case .getCardLists: return "/f9916417-f92e-478e-bfbc-c39e43f7c75b"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCardLists: return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getCardLists: return Data(ofResource: "Cards", withExtension: "json")
        }
    }
    
    var task: Task {
        switch self {
        case .getCardLists:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        var params: [String: String] = [:]
        params["Content-Type"] = "application/json"
        
        return params
    }
}
