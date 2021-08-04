protocol MyPokedexViewModelInput {
    func getMyPokedek()
    func addCardToMyPokedek(card: CardObject)
    func removeCardFromMyPokedek(card: CardObject)
    func navigateToCardListViewController()
}

protocol MyPokedexViewModelOutput: AnyObject {
    var titleText: String { get }
    var addImage: UIImage { get }
    var contentInset: UIEdgeInsets { get }
    var sizeForItem: CGSize { get }
    var minimumInteritemSpacingForSection: CGFloat { get }
    var minimumLineSpacingForSection: CGFloat { get }
    var myPokedexLists: [CardObject] { get set }
    
    var showCardListView: ((CardListViewModelDelegate) -> Void)? { get set }
    var showPokedekLists: (() -> Void)? { get set }
}

protocol MyPokedexViewModelDelegate: AnyObject {
    var input: MyPokedexViewModelInput { get }
    var output: MyPokedexViewModelOutput { get }
}

final class MyPokedexViewModel: MyPokedexViewModelDelegate, MyPokedexViewModelOutput {
    var input: MyPokedexViewModelInput { return self }
    var output: MyPokedexViewModelOutput { return self }
    
    var titleText: String { return "My Pokedek" }
    var addImage: UIImage { return .amtAddImage }
    var contentInset: UIEdgeInsets { return UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)}
    var sizeForItem: CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone
            ? CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.4)
            : CGSize(width: (UIScreen.main.bounds.width), height: (UIScreen.main.bounds.width)*0.25)}
    var minimumInteritemSpacingForSection: CGFloat { return 8 }
    var minimumLineSpacingForSection: CGFloat { return 8 }
    var myPokedexLists: [CardObject] = []
    
    var showCardListView: ((CardListViewModelDelegate) -> Void)?
    var showPokedekLists: (() -> Void)?
}

extension MyPokedexViewModel: MyPokedexViewModelInput {
    
    internal func getMyPokedek() {
        output.showPokedekLists?()
    }
    
    internal func addCardToMyPokedek(card: CardObject) {
        output.myPokedexLists.append(card)
        output.showPokedekLists?()
    }
    
    internal func removeCardFromMyPokedek(card: CardObject) {
        output.myPokedexLists = output.myPokedexLists.filter({$0 != card})
        output.showPokedekLists?()
    }
    
    internal func navigateToCardListViewController() {
        let viewModel: CardListViewModelDelegate = makeViewModel()
        output.showCardListView?(viewModel)
    }
}

extension MyPokedexViewModel {
    private func makeViewModel() -> CardListViewModelDelegate {
        let viewModel = CardListViewModel(myPokedexLists: myPokedexLists)
        return viewModel
    }
}
