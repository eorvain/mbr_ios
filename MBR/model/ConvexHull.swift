//
//  ConvexHull.swift
//  MBR
//
//  Created by Emmanuel Orvain on 27/09/2018.
//  Copyright © 2018 Emmanuel Orvain. All rights reserved.
//

import UIKit

/// Computation of the Minimal Convex Hull with Andrew's monotone chain convex hull algorithm
///
/// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
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
/// _ = ConvexHull().closedConvexHull(allpoints)
/// ```
class ConvexHull {
    
    /// 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
    /// Returns a positive value, if OAB makes a counter-clockwise turn,
    /// negative for clockwise turn, and zero if the points are collinear.
    private func crossProduct(_ O: CGPoint,
                              _  A: CGPoint,
                              _  B: CGPoint) -> CGFloat {
        return (A.x - O.x) * (B.y - O.y) - (A.y - O.y) * (B.x - O.x)
    }
    
    /// Returns a list of points on the convex hull in counter-clockwise order.
    /// Note: the last point in the returned list is the same as the first one.
    ///
    /// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
    ///
    /// - Parameter pointCloud: input point cloud
    /// - Returns: The minimal convex hull
    func closedConvexHull(_ pointCloud : [CGPoint]) -> [CGPoint] {
        // Sort points lexicographically
        // Sort ascending by x coordinate, and if x coordinate are equal, sort ascending by y coordinate.
        // Complexity O(n log n)
        let pointCloudSorted = pointCloud.sorted {
            $0.x == $1.x ? $0.y < $1.y : $0.x < $1.x
        }
        
        // Build the lower hull
        var lower: [CGPoint] = []
        for p in pointCloudSorted {
            while lower.count >= 2 && crossProduct(lower[lower.count-2], lower[lower.count-1], p) <= 0 {
                // removeLast complexity is O(1)
                lower.removeLast()
            }
            // append complexity is O(1)
            lower.append(p)
        }
        
        // Build upper hull
        var upper: [CGPoint] = []
        //reversed complexity is O(1)
        for p in pointCloudSorted.reversed() {
            while upper.count >= 2 && crossProduct(upper[upper.count-2], upper[upper.count-1], p) <= 0 {
                // removeLast complexity is O(1)
                upper.removeLast()
            }
            // append complexity is O(1)
            upper.append(p)
        }
        
        // Last point of upper list is omitted because it is repeated at the
        // beginning of the lower list.
        // removeLast complexity is O(1)
        upper.removeLast()
        
        // Concatenation of the lower and upper hulls gives the convex hull.
        return (upper + lower)
    }
}
