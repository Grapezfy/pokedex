
protocol CardListCellViewModelInput {
    func calcurateData(card: CardObject)
}

protocol CardListCellViewModelOutput: AnyObject {
    var emptyText: String { get }
    var addText: String { get }
    var closeImage: UIImage { get }
    var starImage: UIImage { get }
    var valueLists: [ValueObject] { get set }
    var showStarRating: ((_ index: [Int]) -> Void)? { get set }
    var showValueLists: ((_ data: [ValueObject]) -> Void)? { get set }
}

protocol CardListCellViewModelDelegate: AnyObject {
    var input: CardListCellViewModelInput { get }
    var output: CardListCellViewModelOutput { get }
}

final class CardListCellViewModel: CardListCellViewModelDelegate, CardListCellViewModelOutput {
   
    var input: CardListCellViewModelInput { return self }
    var output: CardListCellViewModelOutput { return self }
 
    var emptyText: String { return "" }
    var addText: String { return "Add" }
    var closeImage: UIImage { return .amtCloseImage }
    var starImage: UIImage { return .amtStarImage }
    var valueLists: [ValueObject] = [
        ValueObject(title: "HP", value: 0.0),
        ValueObject(title: "STR", value: 0.0),
        ValueObject(title: "WEAK", value: 0.0)
    ]
    
    var showStarRating: (([Int]) -> Void)?
    var showValueLists: (([ValueObject]) -> Void)?
}

extension CardListCellViewModel: CardListCellViewModelInput {
    
    internal func calcurateData(card: CardObject) {
        if let rarityRate = card.rarity {
            let array:[Int] = Array(0...rarityRate-1)
            self.output.showStarRating?(array)
        }
        
        var totalDamage: Int = 0
        let weakness = card.weaknesses.count
        
        card.attacks.forEach({ attack in
            guard let damange = attack.damage else { return }
            let damangeInt: Int = damange.isEmpty ? 0 : Int(damange) ?? 0
            totalDamage += damangeInt
        })
        
        let strValue = totalDamage-weakness
        let weakValue = weakness*10
        let screenWidth = UIScreen.main.bounds.width
        let barWidth = screenWidth - (((screenWidth*0.4)-32)*2)/1.5 - 96
      
        if let hpIndex = valueLists.enumerated().filter({$0.element.title == "HP"}).map({$0.offset}).first {
            guard let hpData = card.hp else { return }
            let barRate = CGFloat(barWidth/100.0)*(CGFloat(hpData)/2)
            valueLists[hpIndex].value = barRate
        }
        
        if let strIndex = valueLists.enumerated().filter({$0.element.title == "STR"}).map({$0.offset}).first {
            let barRate = CGFloat(barWidth/100.0)*CGFloat(strValue)
            valueLists[strIndex].value = barRate
        }
        
        if let weakIndex = valueLists.enumerated().filter({$0.element.title == "WEAK"}).map({$0.offset}).first {
            let barRate = CGFloat(barWidth/100.0)*CGFloat(weakValue)
            valueLists[weakIndex].value = barRate
        }
        
        self.output.showValueLists?(valueLists)
    }
}
