//
//  GraphView.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import CoreGraphics
import UIKit
import Then

private struct Constants {
    static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 5.0
}

class GraphView: UIView {
    var startColor: UIColor = .systemMint
    var endColor: UIColor = .systemGreen
    var graphPoints = [4, 2, 6, 5, 6, 8, 3]
    let average = UILabel()
    let maxNum = UILabel()
    let minNum = UILabel()
    var currentDate: Date?
    var labelArray: [UILabel] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context?.drawLinearGradient(gradient,
                                    start: startPoint,
                                    end: endPoint,
                                    options: [])
        
        let margin = viewXRatio(Constants.margin)
        let graphWidth = width - margin * viewXRatio(2) - viewXRatio(4)
        let columnXPoint = { (column: Int) -> CGFloat in
          //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
          return CGFloat(column) * spacing + margin + 1
        }
        let topBorder = viewXRatio(Constants.topBorder)
        let bottomBorder = viewXRatio(Constants.bottomBorder)
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
          let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
          return graphHeight + topBorder - y // Flip the graph
        }
        // draw the line graph

        UIColor.white.setFill()
        UIColor.white.setStroke()
            
        // set up the points line
        let graphPath = UIBezierPath()

        // go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
            
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
          let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
          graphPath.addLine(to: nextPoint)
        }
        
        //Create the clipping path for the graph gradient

        //1 - save the state of the context (commented out for now)
        context?.saveGState()
            
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
            
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
            
        //4 - add the clipping path to the context
        clippingPath.addClip()
            
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
                
        context?.drawLinearGradient(gradient,
                                    start: graphStartPoint,
                                    end: graphEndPoint,
                                    options: [])
        context?.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
          var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
          point.x -= viewXRatio(Constants.circleDiameter / 2)
          point.y -= viewXRatio(Constants.circleDiameter / 2)
              
            let circle = UIBezierPath(ovalIn: CGRect(origin: point,
                                                     size: CGSize(width: viewXRatio(Constants.circleDiameter),
                                                                  height: viewXRatio(Constants.circleDiameter))))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()

        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))

        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))

        //bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
            
        linePath.lineWidth = 1.0
        linePath.stroke()
        createLabels()
        configure()
        setUpUI()
        
        let stackView = UIStackView(arrangedSubviews: labelArray)
        self.addSubview(stackView)
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = viewXRatio(25)
            $0.distribution = .fillEqually
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewXRatio(10)).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: viewXRatio(17)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: width-(viewXRatio(25))).isActive = true
            $0.heightAnchor.constraint(equalToConstant: viewXRatio(40)).isActive = true
        }
    }
    
    func configure() {
        average.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: viewXRatio(30))
            $0.text = "Average"
        }
        maxNum.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: viewXRatio(15))
            $0.text = "MAX"
        }
        minNum.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: viewXRatio(15))
            $0.text = "MIN"
        }
    }
    
    func setUpUI() {
        [ average, maxNum, minNum ].forEach() { self.addSubview($0) }
        
        average.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: viewXRatio(20)).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: viewXRatio(10)).isActive = true
        }
        maxNum.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: viewXRatio(50)).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -viewXRatio(5)).isActive = true
        }
        minNum.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewXRatio(40)).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -viewXRatio(5)).isActive = true
        }
    }
    
    func createLabels() {
        for i in 1..<8 {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: viewXRatio(25))
            label.text = "\(i)"
            labelArray.append(label)
        }
    }
}
