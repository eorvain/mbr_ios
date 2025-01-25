//
//  MBR.swift
//  MBR
//
//  Created by Emmanuel Orvain on 27/09/2018.
//  Copyright © 2018 Emmanuel Orvain. All rights reserved.
//

import UIKit

/// Computation of the MBR (Minimum Bounding Rectangle)
///
/// This algorithm uses the following algorithm sequence :
/// * Convex hull algorithm O(n log(n))
/// * Rotating calippers O(n)
///
/// Usage:
/// ```
/// let p1 = CGPoint(x: 1, y: 0)
/// let p2 = CGPoint(x: 2, y: 1)
/// let p3 = CGPoint(x: 1, y: 1)
/// let p4 = CGPoint(x: 1, y: 2)
/// let p5 = CGPoint(x: 0, y: 1)
///
/// let allpoints = [p1,p2,p3,p4,p5]
/// _ = MBR.compute(allpoints)
/// ```
class MBR {
    
    //MARK:- MBR
    
    /// Compute the MBR. This method uses the "convex hull" and the "rotating calipers" algorithm
    /// in 2D
    ///
    /// * First, we compute the minimal convexhull of the point cloud
    /// * Secondly, for each edge of the convex hull, we rotate the minimal convex hull, so that the
    /// edge is parallel with x axis referential. Then we compute the area of the bounding box.
    /// * When an edge has been rotated and if we found a bounding box area lower than the previous
    /// one, then the angle is recorded as the angle that minmizes the rectangle area.
    /// * Once each edge had been processed, we keep the bounding box and we apply the
    /// opposite rotation.
    /// * We now have the MBR, and we return it.
    /// * The input array must contain more than 3 points.
    ///
    /// - Parameter array: point cloud (no need to be a convex hull)
    /// - Returns: The MBR. (An array of 4 points described by each corner).
    static func compute(_ array: [CGPoint]) -> [CGPoint] {
        guard array.count >= 3 else { return [] }
        
        //compute convex hull
        let convexhull = ConvexHull().closedConvexHull(array)
        
        //compute the edges
        let edges = computeEdgeOfPath(convexhull)
        
        //Let's start with the basic box.
        var minrect = computeBox(convexhull)
        var minarea = computeBoxArea(convexhull)
        var fitAngle: CGFloat = 0.0
        
        //Go find a better orientation to find the MBR.
        for (_, edge) in edges.enumerated() {
            let point1 = edge.0
            let point2 = edge.1
            
            //Compute the angle between the path and referential x-axis
            let angle = angleX(point1, point2)
            //The rotated convex hull
            let convexhullTmp = rotateFromOrigin(convexhull, angle: -angle)
            //The rotated convex hull area
            let area = computeBoxArea(convexhullTmp)
            
            //Make a decision, which orientation gives the minimal area?
            if(area < minarea) {
                print("Found better orientation")
                minarea = area
                minrect = computeBox(convexhullTmp)
                fitAngle = angle
            }
        }
        
        //Here, the minrect is the MBR,
        //but the min rect is aligned with referential x-axis
        
        //Get the rect as a point cloud
        var mbr = computeCorner(minrect)
        //Apply the opposite rotation, and now we have the mbr
        mbr = rotateFromOrigin(mbr, angle: fitAngle)
        
        print("Min area : \(minarea)")
        print("Angle : \(Double(fitAngle) * 180.0 / Double.pi)")
        print("min rect : \(minrect)")
        print("mbr : \(mbr)")
        
        return mbr
    }
    
    //MARK: - FOUNDAMENTALS
    
    /// Distance along the x axis between 2 points
    ///
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: distance along x axis
    static func dx(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat{
        return point2.x - point1.x
    }
    
    /// Distance along the y axis between 2 points
    ///
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: distance along y axis
    static  func dy(_ point1:CGPoint, _ point2: CGPoint) -> CGFloat {
        return point2.y - point1.y
    }
    
    /// Square distance along y axis between 2 points
    ///
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: result
    static  func dy2(_ point1: CGPoint,_ point2: CGPoint) -> CGFloat {
        return pow(point2.y - point1.y, 2)
    }
    
    /// Square distance along x axis between 2 points
    ///
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: result
    static  func dx2(_ point1: CGPoint,_ point2: CGPoint) -> CGFloat {
        return pow(point2.x - point1.x, 2)
    }
    
    /// Euclidian distance between 2 points
    ///
    /// - Parameters:
    ///   - point1: first point
    ///   - point2: second point
    /// - Returns: distance without dimension
    static func distance(_ point1:CGPoint, _ point2: CGPoint) -> CGFloat {
        return sqrt(dx2(point1, point2) + dy2(point1, point2))
    }
    
    /// Barycenter x is the center weighted by all the points.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: point array
    /// - Returns: x barycenter
    static func barycenterX(_ array: [CGPoint]) -> CGFloat {
        let ponderation = 1.0 /  CGFloat(array.count)
        let baryX = array.reduce(0,{$0 + $1.x * ponderation})
        return baryX
    }
    
    /// Barycenter y is the center weighted by all the points.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: point array
    /// - Returns: y barycenter
    static func barycenterY(_ array: [CGPoint]) -> CGFloat {
        let ponderation = 1.0 /  CGFloat(array.count)
        let baryY = array.reduce(0,{$0 + $1.y * ponderation})
        return baryY
    }
    
    /// Barycenter is the center weighted by all the points.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: point array
    /// - Returns: barycenter point
    static func barycenter(_ array: [CGPoint]) -> CGPoint {
        let bary = CGPoint(x: barycenterX(array),
                           y: barycenterY(array))
        return bary
    }
    
    //MARK: - ROTATIONS
    
    /// Angle with the x axis in radian
    ///
    /// - Parameters:
    ///   - point1: point1
    ///   - point2: point2
    /// - Returns: angle in radian
    static func angleX(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return atan2(dy(point1, point2) , dx(point1, point2))
    }
    
    /// Rotation of a point from the origin and with an angle
    ///
    /// - Parameters:
    ///   - point: the point to rotate
    ///   - angle: rotation angle (radian)
    /// - Returns: the rotated point
    static func rotateFromOrigin(_ point: CGPoint, angle: CGFloat) -> CGPoint {
        let s = sin(angle)
        let c = cos(angle)
        return CGPoint(x:c * point.x - s * point.y, y: s * point.x + c * point.y)
    }
    
    /// Rotation of an array of point from the origin and with an angle
    ///
    /// - Parameters:
    ///   - array: the points to rotate
    ///   - angle: rotation angle (radian)
    /// - Returns: the rotated points
    static func rotateFromOrigin(_ array:[CGPoint], angle:CGFloat) -> [CGPoint] {
        return array.map{rotateFromOrigin($0, angle: angle)}
    }
    
    //MARK: - EDGES
    
    /// Compute the edges of a path described by an array of points.
    ///
    /// - Parameter array: path
    /// - Returns: the array of edge. Each edge is a tuple
    static func computeEdgeOfPath(_ array: [CGPoint]) -> [(CGPoint,CGPoint)] {
        if(array.count < 3){
            print("Error : cannot compute edge for an array count less than 3")
            return []
        }
        
        var edges:[(CGPoint, CGPoint)] = []
        
        var previousPoint = array[0]
        for (index,point) in array.enumerated() {
            if index == array.startIndex{
                previousPoint = point
            }
            else if (index+1) == array.endIndex {
                edges += [(previousPoint,point)]
                edges += [(point,array[0])]
            }
            else{
                edges += [(previousPoint,point)]
                previousPoint = point
            }
        }
        
        return edges
    }
    
    //MARK: - BOX COMPUTATION
    /// Minimal x-value from an array of CGPoint.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: array of points
    /// - Returns: the x minimal value
    static func minx(_ array: [CGPoint]) -> CGFloat {
        return array.reduce(CGFloat.greatestFiniteMagnitude, { min($0, $1.x) })
    }
    
    /// Minimal y-value from an array of CGPoint.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: array of points
    /// - Returns: the y minimal value
    static func miny(_ array: [CGPoint]) -> CGFloat {
        return array.reduce(CGFloat.greatestFiniteMagnitude, { min($0, $1.y) })
    }
    
    /// Maximal x-value from an array of CGPoint.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: array of points
    /// - Returns: the x maximal value
    static func maxx(_ array: [CGPoint]) -> CGFloat {
        return array.reduce(-CGFloat.greatestFiniteMagnitude, { max($0, $1.x) })
    }
    
    /// Maximal y-value from an array of CGPoint.
    ///
    /// - Complexity : O(n)
    /// - Parameter array: array of points
    /// - Returns: the y maximal value
    static func maxy(_ array: [CGPoint]) -> CGFloat{
        return array.reduce(-CGFloat.greatestFiniteMagnitude, { max($0, $1.y) })
    }
    
    /// Compute the corners of a CGRect.
    ///
    /// - Parameter rect: rectangle
    /// - Returns: array of four points
    static func computeCorner(_ rect: CGRect) -> [CGPoint] {
        let bottomleft = rect.origin
        let topleft = rect.offsetBy(dx: 0, dy: rect.height).origin
        let topRight = rect.offsetBy(dx: rect.width, dy: rect.height).origin
        let bottomRight = rect.offsetBy(dx: rect.width, dy: 0).origin
        return [bottomleft,topleft,topRight,bottomRight]
    }
    
    /// Compute the bounding rectangle aligned with the x and y axis
    /// of the referential.
    /// This is not the minimal Bounding rectangle
    ///
    /// - Parameter array: the point cloud
    /// - Returns: the rectangle
    static func computeBox(_ array: [CGPoint]) -> CGRect {
        let minx = MBR.minx(array)
        let miny = MBR.miny(array)
        let maxx = MBR.maxx(array)
        let maxy = MBR.maxy(array)
        
        let origin = CGPoint(x:minx,y:miny)
        let size = CGSize(width:maxx - minx,height: maxy-miny)
        
        return CGRect(origin: origin, size: size)
    }
    
    /// Compute the bounding rectangle area, aligned with the x and y axis
    /// of the referential.
    /// This is not the minimal bounding rectangle area.
    ///
    /// - Parameter array: the point cloud
    /// - Returns: the area (without dimension)
    static func computeBoxArea(_ array: [CGPoint]) -> CGFloat {
        let box = computeBox(array)
        let area = rectArea(box)
        return area
    }
    
    /// Area of a CGRect
    ///
    /// - Parameter rect: rectangle
    /// - Returns: area (without dimension)
    static func rectArea(_ rect:CGRect) -> CGFloat {
        return rect.width * rect.height
    }
    
    
}
