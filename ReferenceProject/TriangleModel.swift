//
//  TriangleModel.swift
//  ReferenceProject
//
//  Created by Jack Beegan on 28/02/2017.
//  Copyright © 2017 Ben Reynolds. All rights reserved.
//

import Foundation

class TriangleModel: NSObject {
    convenience init(Start: CGPoint, Scale: Int) {
        self.init()
        self.start = Start
        self.scale = Scale
    }
    
    var start: CGPoint = CGPoint(x: 0, y: 0)
    var scale: Int = 1
    
    func scale(atCenter center: CGPoint) -> [CGPoint] {
        var vertices = [CGPoint]()
        
        vertices.append(center)
        var point = center
        point.x += CGFloat(20) * CGFloat(scale)
        point.y += CGFloat(20) * CGFloat(scale)
        vertices.append(point)
        
        point = center
        point.x += CGFloat(30) * CGFloat(scale)
        point.y += CGFloat(10) * CGFloat(scale)
        vertices.append(point)
        
        return vertices
    }
}
