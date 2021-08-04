struct CardObject: Mappable {
    
    var id: String?
    var name: String?
    var isSelected: Bool?
    var imageUrl: String?
    var hp: Int?
    var rarity: Int?
    var attacks: [AttacksObject] = []
    var weaknesses: [WeaknessesObject] = []
    
    init(id: String?,
         name: String?,
         isSelected: Bool?,
         imageUrl: String?,
         hp: Int?,
         rarity: Int?,
         attacks: [AttacksObject],
         weaknesses: [WeaknessesObject]) {
        
        self.id = id
        self.name = name
        self.isSelected = isSelected
        self.imageUrl = imageUrl
        self.hp = hp
        self.rarity = rarity
        self.attacks = attacks
        self.weaknesses = weaknesses
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        isSelected          <- map["isSelected"]
        imageUrl            <- map["imageUrl"]
        hp                  <- map["hp"]
        rarity              <- map["rarity"]
        attacks             <- map["attacks"]
        weaknesses          <- map["weaknesses"]
    }
}

extension CardObject: Hashable {
    static func == (lhs: CardObject, rhs: CardObject) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.isSelected == rhs.isSelected &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.hp == rhs.hp &&
            lhs.rarity == rhs.rarity &&
            lhs.attacks == rhs.attacks &&
            lhs.weaknesses == rhs.weaknesses
    }
}
