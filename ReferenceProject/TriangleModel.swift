//
//  TriangleModel.swift
//  ReferenceProject
//
//  Created by Jack Beegan on 28/02/2017.
//  Copyright © 2017 Ben Reynolds. All rights reserved.
//

import Foundation
import UIKit

class TriangleModel: NSObject {
    // Convience initializing on called when called directly
    convenience init(x: CGPoint, y: CGPoint, z:CGPoint, Scale: CGFloat) {
        self.init()
        self.scale = Scale
        self.x = x
        self.y = y
        self.z = z
    }
    // Sets these values on initialisation
    var start: CGPoint = CGPoint(x: 0, y: 0)
    var scale: CGFloat = 1
    var x  = CGPoint(x:0, y:0)
    var y  =  CGPoint(x:0, y:0)
    var z  =  CGPoint(x:0, y:0)
    
    // Set the x, y,z points directly.
    func setPoints(x:CGPoint, y: CGPoint, z:CGPoint) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    // Creates an array of CGPoints to be sent to the Triangle View.
    func scale(atCenter center: CGPoint) -> [CGPoint] {
        var vertices = [CGPoint]()
        x = center
        vertices.append(x)
        var point = y
        point.x += point.x * CGFloat(scale)
        point.y += point.y * CGFloat(scale)
        vertices.append(point)
        
        point = z
        point.x += point.x * CGFloat(scale)
        point.y += point.y * CGFloat(scale)
        vertices.append(point)
        
        return vertices
    }
}
