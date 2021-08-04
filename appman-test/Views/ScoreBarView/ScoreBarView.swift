final class ScoreBarView: UIView {
    
    var viewModel: ScoreBarViewModelDelegate!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseBarView: UIView!
    @IBOutlet weak var scoreBarView: UIView!
    @IBOutlet weak var scoreBarWidthConstraints: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        configure(ScoreBarViewModel())
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        configure(ScoreBarViewModel())
        configureView()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: ScoreBarView.self)
        bundle.loadNibNamed(String(describing: ScoreBarView.self), owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Helpers
    func configure(_ viewModel: ScoreBarViewModelDelegate) {
        self.viewModel = viewModel
        bindToViewModel()
    }
    
    private func configureView() {
        
        titleLabel.text = viewModel.output.emptyText
        titleLabel.font = UIFont.systemFont(ofSize: 15)

        baseBarView.backgroundColor = .amtGrayBar
        baseBarView.layer.cornerRadius = 2

        scoreBarView.backgroundColor = .amtRedBar
        scoreBarView.layer.cornerRadius = 2
    }
}

extension ScoreBarView {
    func bindToViewModel() {
        
    }
}
