//
//  MBRPerformance.swift
//  MBRTests
//
//  Created by Emmanuel Orvain on 06/12/2019.
//  Copyright © 2019 Emmanuel Orvain. All rights reserved.
//

import XCTest
@testable import MBR

class MBRPerformance: XCTestCase {

    var pointCloud = [CGPoint]()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test10K_Points() {
        pointCloud = createElementArray(nbElement: 10_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
    
    func test20K_Points() {
        pointCloud = createElementArray(nbElement: 20_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
    
    func test50K_Points() {
        pointCloud = createElementArray(nbElement: 50_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
    
    func test100K_Points() {
        pointCloud = createElementArray(nbElement: 100_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
    
    func test200K_Points() {
        pointCloud = createElementArray(nbElement: 200_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
    
    func test500K_Points() {
        pointCloud = createElementArray(nbElement: 500_000)
        self.measure {
            _ = MBR.compute(pointCloud)
        }
    }
}
