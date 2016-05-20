//
//  AniList_ExampleTests.swift
//  AniList_ExampleTests
//
//  Created by LawLincoln on 16/5/19.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import XCTest
import AniList

class AniList_ExampleTests: XCTestCase {

	override func setUp() {
		super.setUp()
		AniAPIManager.register(<#clientId#>, clientSecret: <#clientSecret#>)
		// Do any additional setup after loading the view, typically from a nib.
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testExample() {
		// This is an example of a functional test case.
		XCTAssert(true, "Pass")
	}

	func asyncTest(timeout: NSTimeInterval = 10, block: (XCTestExpectation) -> ()) {
		let expectation: XCTestExpectation = expectationWithDescription("Swift Expectations")
		block(expectation)
		waitForExpectationsWithTimeout(timeout) { (error) -> Void in
			if error != nil {
				XCTFail("time out: \(error)")
			} else {
				XCTAssert(true, "success")
			}
		}
	}

	func testBrowserAnimate() {
		var filter = BrowserFilter()
		filter.type = .tvShort
//		filter.season = .spring
		filter.includeAiringData = true
		filter.full_page = true
//		if let f = AniAPIManager.manager.lastGenreList.first {
//			filter.genres = [f]
//		}
		filter.page = 3
		asyncTest { (expectation) -> () in
			AniAPI.Browser(filter).execute { (data: [Anime?]) in
				print(data)
				expectation.fulfill()
			}
		}
	}

	func testGenreList() {
		asyncTest { (expectation) -> () in
//			AniAPI.GenreList.execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testSearch() {
		asyncTest { (expectation) -> () in
//			AniAPI.Search("Gundam", .anime).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testSearchStudio() {
		asyncTest { (expectation) -> () in
//			AniAPI.Search("A", .studio).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}

		}
	}

	func testDetailStudio() {
		asyncTest { (expectation) -> () in
			AniAPI.Detail(561, .studio).execute({ (value: [Studio?]) in
				print(value)
				expectation.fulfill()
			})
		}
	}

	func testDetail() {
		asyncTest { (expectation) -> () in
			AniAPI.Detail(20756, .anime).execute { (data: [Anime?]) in
				print(data)
				expectation.fulfill()
			}
		}
	}

	func testPage() {
		asyncTest { (expectation) -> () in
//			AniAPI.Page(20756, .anime).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testCharacters() {
		asyncTest { (expectation) -> () in
//			AniAPI.Characters(20756, .anime).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testStaff() {
		asyncTest { (expectation) -> () in
//			AniAPI.Staff(20756, .anime).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testActors() {
		asyncTest { (expectation) -> () in
//			AniAPI.AnimeActors(20756).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testAiring() {
		asyncTest { (expectation) -> () in
//			AniAPI.AnimeAiring(20756).execute { (data) in
//				print(data)
//				expectation.fulfill()
//			}
		}
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}

}

