import XCTest
@testable import OrderedDictionary

final class OrderedDictionaryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var dict = OrderedDictionary<UUID, String>()
        dict.append(contentsOf: [(UUID(), "a")])
        print(dict)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
