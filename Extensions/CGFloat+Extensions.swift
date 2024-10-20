//
//  CGFloat+Extensions.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/20/24.
//

import CoreGraphics

extension CGFloat {
    /// Two-argument version of clamping.
    func clamped(v1: CGFloat, v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        
        return self < min ? min : (self > max ? max : self)
    }
    
    /// CloseRange version of clamping.
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        let min = range.lowerBound, max = range.upperBound
        
        return self < min ? min : (self > max ? max : self)
    }
}
