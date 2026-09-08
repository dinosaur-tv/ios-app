import XCTest
@testable import DinoHome

final class DinoHomeLoadingTests: XCTestCase {
    func testIgnoresCancelledNavigationErrors() {
        XCTAssertTrue(DinoHomeLoading.shouldIgnore(URLError(.cancelled)))
        XCTAssertFalse(DinoHomeLoading.shouldIgnore(URLError(.timedOut)))
        XCTAssertFalse(DinoHomeLoading.shouldIgnore(nil))
    }
}
