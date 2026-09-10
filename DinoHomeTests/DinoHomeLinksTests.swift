import XCTest
@testable import DinoHome

final class DinoHomeLinksTests: XCTestCase {
    func testSelfHostedServerValidation() {
        // Assert the URL itself: URL.path drops the trailing slash on newer Foundation.
        XCTAssertEqual(
            DinoHomeLinks.serverURL("https://home.example.org")?.absoluteString,
            "https://home.example.org/console/"
        )
        for input in [
            "http://home.example.org", "https://user:pass@home.example.org",
            "https://home.example.org/?token=x", "file:///tmp/x"
        ] {
            XCTAssertNil(DinoHomeLinks.serverURL(input))
        }
    }
    func testKeepsTheOfficialHomeURL() {
        XCTAssertEqual(DinoHomeLinks.sanitized(DinoHomeLinks.homeURL), DinoHomeLinks.homeURL)
    }

    func testRejectsUntrustedAndInsecureLinks() throws {
        XCTAssertEqual(
            DinoHomeLinks.sanitized(try XCTUnwrap(URL(string: "https://example.com/settings"))),
            DinoHomeLinks.homeURL
        )
        XCTAssertEqual(
            DinoHomeLinks.sanitized(try XCTUnwrap(URL(string: "http://home.example.org"))),
            DinoHomeLinks.homeURL
        )
    }
}
