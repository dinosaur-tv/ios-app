import XCTest
@testable import DinoHome

final class DinoHomeLinksTests: XCTestCase {
    func testKeepsTheOfficialHomeURL() {
        XCTAssertEqual(DinoHomeLinks.sanitized(DinoHomeLinks.homeURL), DinoHomeLinks.homeURL)
    }

    func testRejectsUntrustedAndInsecureLinks() {
        XCTAssertEqual(
            DinoHomeLinks.sanitized(URL(string: "https://example.com/settings")!),
            DinoHomeLinks.homeURL
        )
        XCTAssertEqual(
            DinoHomeLinks.sanitized(URL(string: "http://home.dym-dino.ru")!),
            DinoHomeLinks.homeURL
        )
    }
}
