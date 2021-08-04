import Quick
import Nimble

@testable import appman_test

final class CardsSpec: QuickSpec {
    
    override func spec() {
        var response: [String: AnyObject] = [:]
        
        beforeEach {
            do {
                let data = Data(ofResource: "Cards", withExtension: "json")
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                    response = json
                }
            } catch {
                fail("Problem parsing JSON")
            }
        }
        
        describe("call api to get cardObject") {
            context("if status is success") {
                it("should return list of card") {
                    let cardLists = response["cards"]
                    let numberOfCardLists = cardLists?.count
                    
                    expect(numberOfCardLists).toNot(equal(0))
                }
            }
        }
    }
}
