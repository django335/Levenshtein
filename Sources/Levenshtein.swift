//
//  Levenshtein.swift
//  Levenshtein
//
//  Created by naoki morikubo on 2016/03/13.
//  Copyright © 2016年 naoki morikubo. All rights reserved.
//

import Foundation

public enum LevenshteinIgnoreType : Int{
    case None
    case IgnoreCase
    case IgnoreWidth
    case All
}

public class Levenshtein {
    /**
     二つの文字列が同一になる編集距離を返却する
     
     @param str1 一つ目の比較文字列
     
     @param str2 二つ目の比較文字列
     
     @param ignoreType 比較時に許容する文字種差異を指定
     
     @return Int 二つの文字列の差異
     */
    public class func distance(str1:String, str2: String, ignoreType: LevenshteinIgnoreType = .All) -> Int{
        
        var strA = str1
        var strB = str2
        let strASize = strA.characters.count
        let strBSize = strB.characters.count
        
        if strASize == 0 && strBSize == 0 { return 0 }
        if strBSize == 0 { return strASize }
        if strASize == 0 { return strBSize }
        
        if ignoreType != .None {
            if ignoreType == .IgnoreCase || ignoreType == .All {
                strA = strA.lowercaseString
                strB = strB.lowercaseString
            }
            if ignoreType == .IgnoreWidth || ignoreType == .All {
                var mutableStr = NSMutableString(string: strA) as CFMutableString
                CFStringTransform(mutableStr, nil, kCFStringTransformFullwidthHalfwidth, false)
                strA = mutableStr as String
                
                mutableStr = NSMutableString(string: strB) as CFMutableString
                CFStringTransform(mutableStr, nil, kCFStringTransformFullwidthHalfwidth, false)
                strB = mutableStr as String
            }
        }
        
        //        print("\(strA) \(strASize): \(strB) \(strBSize)")
        
        var matrix = [[Int]]()
        for i in 0...strASize {
            matrix.append([i])
        }
        for i in 1...strBSize {
            matrix[0].append(i)
        }
        
        for i in 1...strBSize {
            for j in 1...strASize {
                let idxA = strA.startIndex.advancedBy(j-1)
                let idxB = strB.startIndex.advancedBy(i-1)
                let x = (strA[idxA] == strB[idxB]) ? 0 : 1
                let m = matrix[j-1][i] + 1
                let n = matrix[j][i-1] + 1
                let l = matrix[j-1][i-1] + x
                matrix[j].append(min(m,n,l))
            }
        }
        
        //        print(matrix)
        
        return matrix[strASize][strBSize]
    }
    
    /**
     二つの文字列の類似度を返却する
     
     @param str1 一つ目の比較文字列
     
     @param str2 二つ目の比較文字列
     
     @param ignoreType 比較時に許容する文字種差異を指定
     
     @return Double 二つの文字列の類似度
     */
    public class func normalized_distance(str1:String, str2: String, ignoreType: LevenshteinIgnoreType) -> Double {
        let maxlength = max(str1.characters.count, str2.characters.count)
        if maxlength == 0 {
            return 0.0
        }
        let distance = self.distance(str1, str2: str2, ignoreType: ignoreType)
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
        if str.characters.count == 0 { return nil }
        if list.count == 0 { return nil }
        
        var suggestData: (text: String?, ratio: Double) = (nil, 0.0)
        
        for v in list {
            let resultRatio = self.normalized_distance(str, str2: v, ignoreType: ignoreType)
            if resultRatio > ratio && resultRatio > suggestData.ratio {
                suggestData.text = v
                suggestData.ratio = resultRatio
            }
        }
        
        if suggestData.text != nil {
            return suggestData.text
        }else{
            return nil
        }
    }
}