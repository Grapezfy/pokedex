protocol CardListViewModelInput {
    func getCardLists()
    func removeCardFromList(card: CardObject)
    func searchCardByName(name: String)
    func clearAllSearch()
}

protocol CardListViewModelOutput: AnyObject {
    var contentInset: UIEdgeInsets { get }
    var sizeForItem: CGSize { get }
    var minimumInteritemSpacingForSection: CGFloat { get }
    var minimumLineSpacingForSection: CGFloat { get }
    var cardLists: [CardObject] { get set }
    var myPokedexLists: [CardObject] { get }
    var emptyText: String { get }
    
    var showActivityLoading: (() -> Void)? { get set }
    var hideActivityLoading: (() -> Void)? { get set }
    var showCardLists: (() -> Void)? { get set }
}

protocol CardListViewModelDelegate: AnyObject {
    var input: CardListViewModelInput { get }
    var output: CardListViewModelOutput { get }
}

final class CardListViewModel: CardListViewModelDelegate, CardListViewModelOutput {
    
    private let cardProvider: CardProviderInterface
    private(set) var myPokedexLists: [CardObject]
    
    var input: CardListViewModelInput { return self }
    var output: CardListViewModelOutput { return self }
    
    var contentInset: UIEdgeInsets { return UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)}
    var sizeForItem: CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone
            ? CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.4)
            : CGSize(width: (UIScreen.main.bounds.width*0.9), height: (UIScreen.main.bounds.width*0.9)*0.3)}

    var minimumInteritemSpacingForSection: CGFloat { return 8 }
    var minimumLineSpacingForSection: CGFloat { return 8 }
    var cardLists: [CardObject] = []
    var tempCardLists: [CardObject] = []
    var emptyText: String { return "" }
    
    var showActivityLoading: (() -> Void)?
    var hideActivityLoading: (() -> Void)?
    var showCardLists: (() -> Void)?
    
    init(cardProvider: CardProviderInterface = CardProvider(),
         myPokedexLists: [CardObject]) {
        self.cardProvider = cardProvider
        self.myPokedexLists = myPokedexLists
    }
}

extension CardListViewModel: CardListViewModelInput {
    
    internal func getCardLists() {
        output.showActivityLoading?()
        
        async {  [weak self] in
            guard let strongSelf = self else { return }
            
            do {
                var cardLists = try `await`(strongSelf.cardProvider.getCardsList())
                let myPokedexSet = Set(strongSelf.myPokedexLists)
                cardLists = cardLists.filter({ !myPokedexSet.contains($0) })
                
                main {
                    strongSelf.output.cardLists = cardLists
                    strongSelf.tempCardLists = cardLists
                    strongSelf.output.showCardLists?()
                    
                    strongSelf.output.hideActivityLoading?()
                }
                
            } catch let error {
                print("DEBUG: error \(error.localizedDescription)")
            }
        }
    }
    
    internal func removeCardFromList(card: CardObject) {
        myPokedexLists.append(card)
        
        tempCardLists = output.cardLists.filter({$0 != card})
        output.cardLists = tempCardLists
        
        output.showCardLists?()
    }
    
    internal func searchCardByName(name: String) {
       
        let searchData =
            tempCardLists.filter({($0.name?.range(of: name,
                                                    options: [.caseInsensitive,
                                                              .diacriticInsensitive]) != nil)})
        
        output.cardLists = searchData
        output.showCardLists?()
    }
    
    internal func clearAllSearch() {
        output.cardLists = tempCardLists
        output.showCardLists?()
    }
}
