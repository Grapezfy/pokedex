protocol CardProviderInterface {
    func getCardsList() throws -> Promise<[CardObject]>
}

final class CardProvider: CardProviderInterface {
    
    private let networkManager: Networkable
    
    init(networkManager: Networkable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getCardsList() throws -> Promise<[CardObject]> {
        return async { [weak self] in
            guard let strongSelf = self else { throw NSError() }

            do {

                let response = try `await`(strongSelf.networkManager.request(
                                            target: CardAPIs.getCardLists))
                do {
                    let data = try response.mapArray(CardObject.self , atKeyPath: "cards")
                    return data

                } catch {
                    throw NSError()
                }

            } catch let error {
                print("DEBUG: error \(error.localizedDescription)")
                return []
            }
        }
    }
}
