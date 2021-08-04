final class CardListCell: UICollectionViewCell {

    private var viewModel: CardListCellViewModelDelegate!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addTextLabel: UILabel!
    @IBOutlet weak var removeImageView: UIImageView!
    @IBOutlet var scoreBarView: [ScoreBarView]!
    @IBOutlet var rarityRateView: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(CardListCellViewModel())
        configureView()
    }
    
    private func configure(_ viewModel: CardListCellViewModel) {
        self.viewModel = viewModel
        bindToViewModel()
    }
    
    private func configureView() {
        
        baseView.backgroundColor = .amtPurpleBG
        baseView.layer.cornerRadius = 15
        
        cardName.text = viewModel.output.emptyText
        cardName.font = UIFont.systemFont(ofSize: 15)
        
        addView.isHidden = true
        addView.backgroundColor = .amtRedPrimary
        addView.layer.cornerRadius = 8
        
        addTextLabel.text = viewModel.output.addText
        addTextLabel.textColor = .white
        addTextLabel.textAlignment = .center
        addTextLabel.font = UIFont.systemFont(ofSize: 15)
        
        removeImageView.isHidden = true
        removeImageView.image = viewModel.output.closeImage
        
        scoreBarView.forEach { view in
            view.backgroundColor = .clear
        }
    }
    
    func updateUI(card: CardObject, isMyPokedekLists: Bool) {
        addView.isHidden = isMyPokedekLists
        removeImageView.isHidden = !isMyPokedekLists
        baseView.backgroundColor = isMyPokedekLists ? .amtGrayBG : .amtPurpleBG
        
        if let imageUrl = card.imageUrl {
            cardImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        cardName.text = card.name
        viewModel.input.calcurateData(card: card)
    }
}

extension CardListCell {
    func bindToViewModel() {
        viewModel.output.showStarRating = showStarRating()
        viewModel.output.showValueLists = showValueLists()
    }

    func showStarRating() -> (([Int]) -> Void) {
        return { [weak self] rarityRate in
            guard let strongSelf = self else { return }
            
            for index in 0..<rarityRate.count {
                strongSelf.rarityRateView[index].image = strongSelf.viewModel.output.starImage
            }
        }
    }
    
    func showValueLists() -> (([ValueObject]) -> Void) {
        return { [weak self] valueData in
            guard let strongSelf = self else { return }
            
            for index in 0..<valueData.count {
                strongSelf.scoreBarView[index].titleLabel.text = valueData[index].title
                strongSelf.scoreBarView[index].scoreBarWidthConstraints.constant = valueData[index].value
            }
        }
    }
}

