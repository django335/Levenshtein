//
//  Levenshtein.swift
//  Levenshtein
//
//  Created by naoki morikubo on 2016/03/13.
//  Copyright © 2016年 naoki morikubo. All rights reserved.
//

import Foundation
import CoreFoundation

 public struct LevenshteinIgnoreType : OptionSetType {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }

  static let IgnoreCase  = LevenshteinIgnoreType(rawValue: 0x1 << 0)
  static let IgnoreWidth = LevenshteinIgnoreType(rawValue: 0x1 << 1)
  static let All = LevenshteinIgnoreType([IgnoreCase, IgnoreWidth])
}

public class Levenshtein {
    /**
     二つの文字列が同一になる編集距離を返却する

     @param lhs 左辺の比較文字列

     @param rhs 右辺の比較文字列

     @param ignoreType 比較時に許容する文字種差異を指定

     @return Int 二つの文字列の差異
     */
    public class func distance(var lhs lhs:String, var rhs: String, ignoreType: LevenshteinIgnoreType = []) -> Int{

        let lhsSize = lhs.characters.count
        let rhsSize = rhs.characters.count

        if lhsSize == 0 && rhsSize == 0 { return 0 }
        if rhsSize == 0 { return lhsSize }
        if lhsSize == 0 { return rhsSize }


        if ignoreType.contains(.IgnoreCase) {
          lhs = lhs.lowercaseString
          rhs = rhs.lowercaseString
        }

        if ignoreType.contains(.IgnoreWidth) {
          #if os(Linux)
            var mutableStr = NSMutableString(string: lhs)
            var mutableCfStr:CFMutableString = unsafeBitCast(mutableStr, CFMutableString.self)
            CFStringTransform(mutableCfStr, nil, kCFStringTransformFullwidthHalfwidth, false)
            lhs = String(mutableCfStr)

            mutableStr = NSMutableString(string: rhs)
            mutableCfStr = unsafeBitCast(mutableStr, CFMutableString.self)
            CFStringTransform(mutableCfStr, nil, kCFStringTransformFullwidthHalfwidth, false)
            rhs = String(mutableCfStr)
          #else
            var mutableStr = NSMutableString(string: lhs) as CFMutableString
            CFStringTransform(mutableStr, nil, kCFStringTransformFullwidthHalfwidth, false)
            lhs = mutableStr as String

            mutableStr = NSMutableString(string: rhs) as CFMutableString
            CFStringTransform(mutableStr, nil, kCFStringTransformFullwidthHalfwidth, false)
            rhs = mutableStr as String
          #endif
        }


        var matrix = [[Int]]()
        for i in 0...lhsSize {
            matrix.append([i])
        }

        for i in 1...rhsSize {
            matrix[0].append(i)
        }
        
        for i in 1...rhsSize {
            for j in 1...lhsSize {
                let idxLhs = lhs.startIndex.advancedBy(j-1)
                let idxRhs = rhs.startIndex.advancedBy(i-1)
                let x = (lhs[idxLhs] == rhs[idxRhs]) ? 0 : 1
                let m = matrix[j-1][i] + 1
                let n = matrix[j][i-1] + 1
                let l = matrix[j-1][i-1] + x
                matrix[j].append(min(m,n,l))
            }
        }

        return matrix[lhsSize][rhsSize]
    }
    
    /**
     二つの文字列の類似度を返却する

     @param lhs 左辺の比較文字列

     @param rhs 右辺の比較文字列

     @param ignoreType 比較時に許容する文字種差異を指定

     @return Double 二つの文字列の類似度
     */
    public class func normalized_distance(lhs lhs:String, rhs: String, ignoreType: LevenshteinIgnoreType = []) -> Double {
        let maxlength = max(lhs.characters.count, rhs.characters.count)
        guard maxlength > 0 else { return 0.0 }

        let distance = self.distance(lhs: lhs, rhs: rhs, ignoreType: ignoreType)
        let ratio = 1.0 - (Double(distance) / Double(maxlength))
        return ratio
    }
    
    /**
     対象文字列に最も近い候補をリストから抽出、返却する
     
     @param str 検査対象文字列

     @param list 候補文字列リスト

     @param ratio サジェスト対象にする下限類似度

     @param ignoreType 比較時に許容する文字種差異を指定

     @return String? サジェスト対象を返却。候補文字列が存在しない場合はnilを返す。
     */
    public class func suggest(str:String, list:Array<String>, ratio: Double, ignoreType: LevenshteinIgnoreType) -> String? {
        guard str.characters.count > 0 && list.count > 0 else { return nil }

        var suggestData: (text: String?, ratio: Double) = (nil, 0.0)

        for v in list {
          let resultRatio = self.normalized_distance(lhs: str, rhs: v, ignoreType: ignoreType)
            if resultRatio > ratio && resultRatio > suggestData.ratio {
                suggestData.text = v
                suggestData.ratio = resultRatio
            }
        }

        return suggestData.text
    }
}
