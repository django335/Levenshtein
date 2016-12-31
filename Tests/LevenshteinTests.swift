//
//  LevenshteinTests.swift
//  LevenshteinTests
//
//  Created by naoki morikubo on 2016/03/13.
//  Copyright © 2016年 naoki morikubo. All rights reserved.
//

import XCTest
@testable import Levenshtein

class LevenshteinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLevenshteinDistance() {
        let str1 = "aaaa"
        let str2 = "aAａb"
        var distance = Levenshtein.distance(str1, str2: str2, ignoreType: .all)
        XCTAssertEqual(1, distance, "ignoreTypeがAllの場合編集距離は1")
        var ratio = Levenshtein.normalized_distance(str1, str2: str2, ignoreType: .all)
        XCTAssertEqual(0.75, ratio, "ignoreTypeがAllの場合類似度は0.25")
        
        distance = Levenshtein.distance(str1, str2: str2, ignoreType: .ignoreCase)
        XCTAssertEqual(2, distance, "ignoreTypeがIgnoreCaseの場合編集距離は2")

        ratio = Levenshtein.normalized_distance(str1, str2: str2, ignoreType: .ignoreCase)
        XCTAssertEqual(0.5, ratio, "ignoreTypeがIgnoreCaseの場合類似度は0.5")
        
        distance = Levenshtein.distance(str1, str2: str2, ignoreType: .ignoreWidth)
        XCTAssertEqual(2, distance, "ignoreTypeがIgnoreWidthの場合編集距離は2")
        
        ratio = Levenshtein.normalized_distance(str1, str2: str2, ignoreType: .ignoreWidth)
        XCTAssertEqual(0.5, ratio, "ignoreTypeがIgnoreWidthの場合類似度は0.5")
        
        distance = Levenshtein.distance(str1, str2: str2, ignoreType: .none)
        XCTAssertEqual(3, distance, "ignoreTypeがNoneの場合編集距離は3")
        
        ratio = Levenshtein.normalized_distance(str1, str2: str2, ignoreType: .none)
        XCTAssertEqual(0.25, ratio, "ignoreTypeがNoneの場合類似度は0.25")
    }
    
    func testSuggest() {
        let sampleList = ["gmail.com", "yahoo.co.jp", "outlook.com"]
        let testTxt = "gmaii.con"
        
        var suggestResult = Levenshtein.suggest(testTxt, list: sampleList, ratio: 0.6, ignoreType: .ignoreWidth)
        XCTAssertEqual("gmail.com", suggestResult, "ratioが0.6の場合gmail.comがサジェストされる")
        
        suggestResult = Levenshtein.suggest(testTxt, list: sampleList, ratio: 0.9, ignoreType: .ignoreWidth)
        XCTAssertNil(suggestResult, "ratioが0.9の場合nilが返る")
    }
    
}
