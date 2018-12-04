#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(AppTests.allTests),
])

#endif
