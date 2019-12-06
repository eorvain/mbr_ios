//
//  MockSpring.swift
//  MBRTests
//
//  Created by Emmanuel Orvain on 06/12/2019.
//  Copyright © 2019 Emmanuel Orvain. All rights reserved.
//

import Foundation
import UIKit

func createElementArray(nbElement n :Int)->[Int]{
    print("Build array of \(n) elements...")
    var a = [Int](repeating: 0, count: n)
    for i in 0..<n {
      let j = Int.random(in: 0...i)
      // for the Fisher–Yates_shuffle's pseudo code implement in wiki, it will check if i != j
      a[i] = a[j]
      a[j] = i
    }
    print("OK")
    return a
}

func createElementArray(nbElement n :Int,
                        maxX:CGFloat = 100,
                        maxY:CGFloat = 100)->[CGPoint]{
    print("Build array of \(n) elements...")
    var a = [CGPoint]()
    for _ in 0..<n {
      let j = CGFloat.random(in: 0...maxX)
      let k = CGFloat.random(in: 0...maxY)
        a.append(CGPoint(x: j, y: k))
    }
    print("OK")
    return a
}
