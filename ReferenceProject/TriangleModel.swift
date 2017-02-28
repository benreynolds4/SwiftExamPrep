//
//  TriangleModel.swift
//  ReferenceProject
//
//  Created by Jack Beegan on 28/02/2017.
//  Edited by Eoin Falconer on 28/02/2017.
//  Copyright © 2017 Ben Reynolds. All rights reserved.
//

import Foundation
import UIKit

class TriangleModel: NSObject {
    convenience init(Scale: CGFloat, Rotate: Int) {
        self.init()
        self.scaleAmount = Scale
        self.rotateAmount = Rotate
    }
    
    var scaleAmount: CGFloat = 1
    var rotateAmount: Int = 0
    var verticies: [CGPoint] = [CGPoint(x:100,y:100), CGPoint(x:150,y:0), CGPoint(x:50,y:75)]
    
    func scale() -> [CGPoint] {
        var changedVerticies: [CGPoint] = []
        for var vertex in self.verticies {
            vertex.x = vertex.x * self.scaleAmount
            vertex.y = vertex.y * self.scaleAmount
            changedVerticies.append(CGPoint(x: vertex.x, y: vertex.y))
        }
        self.verticies = changedVerticies
        return self.verticies
    }
    func rotate() -> [CGPoint] {
        print("In the rotate method")
        var changedVerticies: [CGPoint] = []
        for var vertex in self.verticies {
            vertex.x = vertex.x + CGFloat(self.rotateAmount)
            vertex.y = vertex.y + CGFloat(self.rotateAmount)
            changedVerticies.append(CGPoint(x: vertex.x, y: vertex.y))
        }
        self.verticies = changedVerticies
        print(verticies)
        return self.verticies
    }
}
