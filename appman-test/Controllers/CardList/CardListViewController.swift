
private var reuseIdentifier = "CardListCell"

protocol CardListViewControllerDelegate: AnyObject {
    func addCardToMyPokedek(card: CardObject)
}

final class CardListViewController: UIViewController {

    private var viewModel: CardListViewModelDelegate!
    weak var delegate: CardListViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
    }
    
    func configure(_ viewModel: CardListViewModelDelegate) {
        self.viewModel = viewModel
        bindToViewModel()
    }
    
    private func configureView() {
        searchBar.delegate = self
        viewModel.input.getCardLists()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = viewModel.output.contentInset
        collectionView.collectionViewLayout = getLayout()
        
        collectionView.register(UINib(nibName: reuseIdentifier,
                                      bundle: Bundle.main),
                                forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func getLayout() -> UICollectionViewLayout {
        let layout:UICollectionViewFlowLayout =  UICollectionViewFlowLayout()

        layout.itemSize = UIDevice.current.userInterfaceIdiom == .phone
            ? CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.4)
            : CGSize(width: collectionView.frame.width, height: collectionView.frame.width*0.3)
        
        layout.minimumLineSpacing = viewModel.output.minimumLineSpacingForSection
        layout.minimumInteritemSpacing = viewModel.output.minimumInteritemSpacingForSection

        return layout as UICollectionViewLayout
    }
    
    @objc private func handleAddCard(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        let card = viewModel.output.cardLists[index]
        delegate?.addCardToMyPokedek(card: card)
        
        viewModel.input.removeCardFromList(card: card)
    }
}

extension CardListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.cardLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CardListCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,for: indexPath) as? CardListCell else {
            
            return UICollectionViewCell()
        }
     
        let card = viewModel.output.cardLists[indexPath.row]
        cell.updateUI(card: card, isMyPokedekLists: false)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleAddCard(_:)))
        
        cell.addView.tag = indexPath.row
        cell.addView.addGestureRecognizer(gesture)
        
        return cell
    }
}

extension CardListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.input.clearAllSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? viewModel.output.emptyText
        
        if searchText.isEmpty {
            viewModel.input.clearAllSearch()
        } else {
            viewModel.input.searchCardByName(name: searchText)
        }
        
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if let searchText = searchBar.text ,
           let textRange = Range(range, in: searchText) {
            let updatedText = searchText.replacingCharacters(in: textRange, with: text)
        
            if updatedText.isEmpty {
                viewModel.input.clearAllSearch()
            } else {
                viewModel.input.searchCardByName(name: updatedText)
            }
        }

        return true
    }
}

extension CardListViewController {
    func bindToViewModel() {
        viewModel.output.showActivityLoading = showActivityLoading()
        viewModel.output.hideActivityLoading = hideActivityLoading()
        viewModel.output.showCardLists = showCardLists()
    }
    
    func showActivityLoading() -> (() -> Void) {
        return { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicatorView.startAnimating()
        }
    }
    
    func hideActivityLoading() -> (() -> Void) {
        return { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicatorView.stopAnimating()
        }
    }
    
    func showCardLists() -> (() -> Void) {
        return { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.layoutIfNeeded()
        }
    }
}

