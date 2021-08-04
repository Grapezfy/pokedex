struct WeaknessesObject: Mappable {
    var type: String?
    var value: String?
    
    init(type: String?, value: String?) {
        self.type = type
        self.value = value
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        type             <- map["type"]
        value            <- map["value"]
    }
}

extension WeaknessesObject: Hashable {
    static func == (lhs: WeaknessesObject, rhs: WeaknessesObject) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.value == rhs.value
    }
}
