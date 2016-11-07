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
        let lhs = "aaaa"
        let rhs = "aAａb"
        var distance = Levenshtein.distance(lhs: lhs, rhs: rhs, ignoreType: .All)
        XCTAssertEqual(1, distance, "ignoreTypeがAllの場合編集距離は1")

        var ratio = Levenshtein.normalized_distance(lhs: lhs, rhs: rhs, ignoreType: .All)
        XCTAssertEqual(0.75, ratio, "ignoreTypeがAllの場合類似度は0.25")
        
        distance = Levenshtein.distance(lhs: lhs, rhs: rhs, ignoreType: .IgnoreCase)
        XCTAssertEqual(2, distance, "ignoreTypeがIgnoreCaseの場合編集距離は2")

        ratio = Levenshtein.normalized_distance(lhs: lhs, rhs: rhs, ignoreType: .IgnoreCase)
        XCTAssertEqual(0.5, ratio, "ignoreTypeがIgnoreCaseの場合類似度は0.5")
        
        distance = Levenshtein.distance(lhs: lhs, rhs: rhs, ignoreType: .IgnoreWidth)
        XCTAssertEqual(2, distance, "ignoreTypeがIgnoreWidthの場合編集距離は2")
        
        ratio = Levenshtein.normalized_distance(lhs: lhs, rhs: rhs, ignoreType: .IgnoreWidth)
        XCTAssertEqual(0.5, ratio, "ignoreTypeがIgnoreWidthの場合類似度は0.5")
        
        distance = Levenshtein.distance(lhs: lhs, rhs: rhs)
        XCTAssertEqual(3, distance, "ignoreTypeが未設定の場合編集距離は3")
        
        ratio = Levenshtein.normalized_distance(lhs: lhs, rhs: rhs)
        XCTAssertEqual(0.25, ratio, "ignoreTypeが未設定の場合類似度は0.25")
    }
    
    func testSuggest() {
        let sampleList = ["gmail.com", "yahoo.co.jp", "outlook.com"]
        let testTxt = "gmaii.con"
        
        var suggestResult = Levenshtein.suggest(testTxt, list: sampleList, ratio: 0.6, ignoreType: .IgnoreWidth)
        XCTAssertEqual("gmail.com", suggestResult, "ratioが0.6の場合gmail.comがサジェストされる")
        
        suggestResult = Levenshtein.suggest(testTxt, list: sampleList, ratio: 0.9, ignoreType: .IgnoreWidth)
        XCTAssertNil(suggestResult, "ratioが0.9の場合nilが返る")

        suggestResult = Levenshtein.suggest("", list: sampleList, ratio: 0.9, ignoreType: .IgnoreWidth)
        XCTAssertNil(suggestResult, "strが空文字の場合nilが返る")

        suggestResult = Levenshtein.suggest(testTxt, list: [], ratio: 0.9, ignoreType: .IgnoreWidth)
        XCTAssertNil(suggestResult, "listが空配列の場合nilが返る")
    }
    
}
