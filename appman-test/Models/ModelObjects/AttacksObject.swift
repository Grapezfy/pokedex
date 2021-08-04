struct AttacksObject: Mappable {
    var name: String?
    var damage: String?
    
    init(name: String?, damage: String?) {
        self.name = name
        self.damage = damage
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name              <- map["name"]
        damage            <- map["damage"]
    }
}

extension AttacksObject: Hashable {
    static func == (lhs: AttacksObject, rhs: AttacksObject) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.damage == rhs.damage
    }
}
