//
//  MBRTests.swift
//  MBRTests
//
//  Created by Emmanuel Orvain on 27/09/2018.
//  Copyright © 2018 Emmanuel Orvain. All rights reserved.
//

import XCTest
@testable import MBR

class MBRTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvexHull() {
        let p1 = CGPoint(x: 1, y: 0)
        let p2 = CGPoint(x: 2, y: 1)
        let p3 = CGPoint(x: 1, y: 1)
        let p4 = CGPoint(x: 1, y: 2)
        let p5 = CGPoint(x: 0, y: 1)
        
        let allpoints = [p1,p2,p3,p4,p5]
        let hull = ConvexHull().closedConvexHull(allpoints)
        print("Hull : \(hull)")
    }
    
    func testMBRdx(){
        let precision = 0.000001
        let p1 = CGPoint(x:-10,y:30)
        let p2 = CGPoint(x:10,y:-100)
        var res = MBR.dx(p1,p2)
        XCTAssertEqual(Double(res), 20.0, accuracy: precision)
        res = MBR.dx(p2,p1)
        XCTAssertEqual(Double(res), -20.0, accuracy: precision)
    }
    
    func testMBRdx2(){
        let precision = 0.000001
        let p1 = CGPoint(x:-10,y:30)
        let p2 = CGPoint(x:10,y:-100)
        var res = MBR.dx2(p1,p2)
        XCTAssertEqual(Double(res), 400.0, accuracy: precision)
        res = MBR.dx2(p2,p1)
        XCTAssertEqual(Double(res), 400.0, accuracy: precision)
    }
    
    func testMBRdy(){
        let precision = 0.001
        let p1 = CGPoint(x:-10,y:30)
        let p2 = CGPoint(x:10,y:-100)
        var res = MBR.dy(p1,p2)
        XCTAssertEqual(Double(res), -130.0, accuracy: precision)
        res = MBR.dy(p2,p1)
        XCTAssertEqual(Double(res), 130.0, accuracy: precision)
    }
    
    func testMBRdy2(){
        let precision = 0.001
        let p1 = CGPoint(x:-10,y:30)
        let p2 = CGPoint(x:10,y:-100)
        var res = MBR.dy2(p1,p2)
        XCTAssertEqual(Double(res), 16900.0, accuracy: precision)
        res = MBR.dy2(p2,p1)
        XCTAssertEqual(Double(res), 16900.0, accuracy: precision)
    }
    
    func testMBRDistance(){
        let precision = 0.001
        let p1 = CGPoint(x:-5,y:5)
        let p2 = CGPoint(x:5,y:-5)
        let res = MBR.distance(p1,p2)
        XCTAssertEqual(Double(res), 14.142, accuracy: precision)
    }
    
    func testMBRXangle(){
        let precision = 0.001
        let p1 = CGPoint(x:-5,y:-5)
        let p2 = CGPoint(x:5,y:5)
        var res = MBR.angleX(p1,p2)
        XCTAssertEqual(Double(res), Double.pi / 4.0, accuracy: precision)
        res = MBR.angleX(p2,p1)
        XCTAssertEqual(Double(res), -Double.pi * 3 / 4.0, accuracy: precision)
    }
    
    func testMBRPointRotationAroundOrigin(){
        let precision = 0.001
        let p1 = CGPoint(x:5,y:0)
        let p2 = CGPoint(x:0,y:5)
        let p3 = MBR.rotateFromOrigin(p1, angle: CGFloat(Double.pi / 4.0))
        XCTAssertEqual(Double(p3.x), 3.535, accuracy: precision)
        XCTAssertEqual(Double(p3.y), 3.535, accuracy: precision)
        let p4 = MBR.rotateFromOrigin(p2, angle: CGFloat(Double.pi / 4.0))
        XCTAssertEqual(Double(p4.x), -3.535, accuracy: precision)
        XCTAssertEqual(Double(p4.y), 3.535, accuracy: precision)
    }
    
    func testMBREdge(){
        let precision:CGFloat = 0.001
        let p1 = CGPoint(x: 1, y: 0)
        let p2 = CGPoint(x: 2, y: 1)
        let p3 = CGPoint(x: 1, y: 2)
        let p4 = CGPoint(x: 0, y: 1)
        
        let path = [p1,p2,p3,p4]
        
        let edges = MBR.computeEdgeOfPath(path)
        XCTAssertEqual(edges[0].0.x, CGFloat(1.0), accuracy: precision)
        XCTAssertEqual(edges[0].0.y, CGFloat(0.0), accuracy: precision)
        
        XCTAssertEqual(edges[0].1.x, CGFloat(2.0), accuracy: precision)
        XCTAssertEqual(edges[0].1.y, CGFloat(1.0), accuracy: precision)
        
        XCTAssertEqual(edges[1].0.x, CGFloat(2.0), accuracy: precision)
        XCTAssertEqual(edges[1].0.y, CGFloat(1.0), accuracy: precision)
        
        XCTAssertEqual(edges[1].1.x, CGFloat(1.0), accuracy: precision)
        XCTAssertEqual(edges[1].1.y, CGFloat(2.0), accuracy: precision)
        
        XCTAssertEqual(edges[2].0.x, CGFloat(1.0), accuracy: precision)
        XCTAssertEqual(edges[2].0.y, CGFloat(2.0), accuracy: precision)
        
        XCTAssertEqual(edges[2].1.x, CGFloat(0.0), accuracy: precision)
        XCTAssertEqual(edges[2].1.y, CGFloat(1.0), accuracy: precision)
        
        XCTAssertEqual(edges[3].0.x, CGFloat(0.0), accuracy: precision)
        XCTAssertEqual(edges[3].0.y, CGFloat(1.0), accuracy: precision)
        
        XCTAssertEqual(edges[3].1.x, CGFloat(1.0), accuracy: precision)
        XCTAssertEqual(edges[3].1.y, CGFloat(0.0), accuracy: precision)
    }
    
    func testMaxMin(){
        let precision:CGFloat = 0.001
        let p1 = CGPoint(x: -10, y: 0)
        let p2 = CGPoint(x: 0, y: 5)
        let p3 = CGPoint(x: 10, y: -5)
        let array = [p1,p2,p3]
        
        let maxx = MBR.maxx(array)
        let maxy = MBR.maxy(array)
        let minx = MBR.minx(array)
        let miny = MBR.miny(array)
        
        XCTAssertEqual(maxx, 10.0, accuracy: precision)
        XCTAssertEqual(maxy, 5.0, accuracy: precision)
        XCTAssertEqual(minx, -10.0, accuracy: precision)
        XCTAssertEqual(miny, -5.0, accuracy: precision)
        
        let box = MBR.computeBox(array)
        XCTAssertEqual(box.origin.x, -10.0, accuracy: precision)
        XCTAssertEqual(box.origin.y, -5.0, accuracy: precision)
        XCTAssertEqual(box.width, 20.0, accuracy: precision)
        XCTAssertEqual(box.height, 10.0, accuracy: precision)
        
        let area = MBR.computeBoxArea(array)
        XCTAssertEqual(area, 200.0, accuracy: precision)
    }
    
    func testMaxMin2(){
        let precision:CGFloat = 0.001
        let p1 = CGPoint(x: -10, y: -5)
        let p2 = CGPoint(x: -4, y: -2)
        let array = [p1,p2,]
        
        let maxx = MBR.maxx(array)
        let maxy = MBR.maxy(array)
        let minx = MBR.minx(array)
        let miny = MBR.miny(array)
        
        XCTAssertEqual(maxx, -4.0, accuracy: precision)
        XCTAssertEqual(maxy, -2.0, accuracy: precision)
        XCTAssertEqual(minx, -10.0, accuracy: precision)
        XCTAssertEqual(miny, -5.0, accuracy: precision)
        
        let box = MBR.computeBox(array)
        XCTAssertEqual(box.origin.x, -10.0, accuracy: precision)
        XCTAssertEqual(box.origin.y, -5.0, accuracy: precision)
        XCTAssertEqual(box.width, 6.0, accuracy: precision)
        XCTAssertEqual(box.height, 3.0, accuracy: precision)
        
        let area = MBR.computeBoxArea(array)
        XCTAssertEqual(area, 18.0, accuracy: precision)
    }
    
    
    func testMBR() {
        let p1 = CGPoint(x: 1, y: 0)
        let p2 = CGPoint(x: 2, y: 1)
        let p3 = CGPoint(x: 1, y: 1)
        let p4 = CGPoint(x: 1, y: 2)
        let p5 = CGPoint(x: 0, y: 1)
        
        let allpoints = [p1,p2,p3,p4,p5]
        _ = MBR.compute(allpoints)
        
    }
}
