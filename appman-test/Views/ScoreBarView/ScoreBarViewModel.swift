protocol ScoreBarViewModelInput {
    
}

protocol ScoreBarViewModelOutput: AnyObject {
    var emptyText: String { get }
}

protocol ScoreBarViewModelDelegate: AnyObject {
    var input: ScoreBarViewModelInput { get }
    var output: ScoreBarViewModelOutput { get }
}

final class ScoreBarViewModel: ScoreBarViewModelDelegate, ScoreBarViewModelOutput {
    var input: ScoreBarViewModelInput { return self }
    var output: ScoreBarViewModelOutput { return self }
    
    var emptyText: String { return "" }
}

extension ScoreBarViewModel: ScoreBarViewModelInput {
    
}
