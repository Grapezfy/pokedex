
private let cardListSegue = "PushToCardListView"
private var reuseIdentifier = "CardListCell"

final class MyPokedexViewController: UIViewController {

    private var viewModel: MyPokedexViewModelDelegate!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(MyPokedexViewModel())
        configureView()
        configureCollectionView()
    }
    
    func configure(_ viewModel: MyPokedexViewModelDelegate) {
        self.viewModel = viewModel
        bindToViewModel()
    }
    
    private func configureView() {
        titleLabel.text = viewModel.output.titleText
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        bottomView.backgroundColor = .amtRedPrimary
     
        addImageView.image = viewModel.output.addImage
        addImageView.layer.shadowColor = UIColor.black.cgColor
        addImageView.layer.shadowRadius = 3.0
        addImageView.layer.shadowOpacity = 0.1
        addImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        addImageView.layer.masksToBounds = false
        
        viewModel.input.getMyPokedek()
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
        
        layout.itemSize = viewModel.output.sizeForItem
        layout.minimumLineSpacing = viewModel.output.minimumLineSpacingForSection
        layout.minimumInteritemSpacing = viewModel.output.minimumInteritemSpacingForSection
        
        return layout as UICollectionViewLayout
    }
    
    @IBAction func handleAddCard(_ sender: Any) {
        viewModel.input.navigateToCardListViewController()
    }
    
    @objc private func handleRemoveCardFromMyPokedek(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        let card = viewModel.output.myPokedexLists[index]
        viewModel.input.removeCardFromMyPokedek(card: card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let viewController as CardListViewController where segue.identifier == cardListSegue:
            guard let viewModel = sender as? CardListViewModelDelegate else { return }
            viewController.delegate = self
            viewController.configure(viewModel)
        default: break
        }
    }
}

extension MyPokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.myPokedexLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CardListCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,for: indexPath) as? CardListCell else {
            
            return UICollectionViewCell()
        }
     
        let card = viewModel.output.myPokedexLists[indexPath.row]
        cell.updateUI(card: card, isMyPokedekLists: true)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleRemoveCardFromMyPokedek(_:)))
        
        cell.removeImageView.tag = indexPath.row
        cell.removeImageView.addGestureRecognizer(gesture)
        
        return cell
    }
}

extension MyPokedexViewController: CardListViewControllerDelegate {
    func addCardToMyPokedek(card: CardObject) {
        viewModel.input.addCardToMyPokedek(card: card)
    }
}

extension MyPokedexViewController {
    func bindToViewModel() {
        viewModel.output.showCardListView = showCardListView()
        viewModel.output.showPokedekLists = showPokedekLists()
    }
    
    func showCardListView() -> ((CardListViewModelDelegate) -> Void) {
        return { [weak self] viewModel in
            
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: cardListSegue, sender: viewModel)
        }
    }
    
    func showPokedekLists() -> (() -> Void) {
        return { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.layoutIfNeeded()
        }
    }
}
