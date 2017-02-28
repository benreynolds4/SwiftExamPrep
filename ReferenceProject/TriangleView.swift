//
//  TriangleView.swift
//  ReferenceProject
//
//  Created by Ben Reynolds on 28/02/2017.
//  Copyright © 2017 Ben Reynolds. All rights reserved.
//


import Foundation
import UIKit

protocol TriangleViewDataSource: class {
    func scale(sender: TriangleView) -> [CGPoint]?
}

@IBDesignable class TriangleView: UIView {
    @IBInspectable var fillColor: UIColor = UIColor.blue
    @IBInspectable var strokeColor: UIColor = UIColor.green
    @IBInspectable var lineWidth: Float = 1.5
    var path = UIBezierPath()
    var rect:CGRect = CGRect()
    
    weak var dataSource: TriangleViewDataSource?
    
    var triangleScale: CGFloat = 0.95 {
        didSet {
            setNeedsDisplay()
        }
    }
   
    override func draw(_ rect: CGRect) {
        if let vertices = dataSource?.scale(sender: self) {
            // join spirograph vertices
            path = UIBezierPath()
            path.move(to: vertices[0])
            for vertex in vertices[1..<vertices.count] {
                path.addLine(to: vertex)
            }
            strokeColor.setStroke()
            path.lineWidth = CGFloat(lineWidth)
            path.stroke()
            fillColor.setFill()
            path.fill()
        }

    
    }
}
