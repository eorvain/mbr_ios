//
//  ViewController.swift
//  MBR
//
//  Created by Emmanuel Orvain on 27/09/2018.
//  Copyright © 2018 Emmanuel Orvain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var drawImage = UIImageView(frame:CGRect.zero)
    var btnRestart = UIButton()
    
    var pointCloud:[CGPoint] = []
    var convexhull:[CGPoint] = []
    var mbr:[CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRestart.setTitle("Restart", for: .normal)
        btnRestart.addTarget(self, action: #selector(restartTapped(sender:)), for: .touchUpInside)
    
        drawImage = UIImageView(frame: view.frame)
        
        //The setup code (in viewDidLoad in your view controller)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        drawImage.addGestureRecognizer(tapGesture)

        view.addSubview(drawImage)
        view.addSubview(btnRestart)
        
        buildStyle()
        buildConstraints()
    }
    
    private func buildStyle(){
        drawImage.layer.borderWidth = 2.0
        drawImage.layer.borderColor = UIColor.brown.cgColor
        drawImage.backgroundColor = UIColor.lightGray
        drawImage.isUserInteractionEnabled = true
    }
    
    private func buildConstraints(){
        drawImage.translatesAutoresizingMaskIntoConstraints = false
        btnRestart.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            drawImage.topAnchor.constraint(equalTo: guide.topAnchor),
            drawImage.leftAnchor.constraint(equalTo: guide.leftAnchor),
            drawImage.widthAnchor.constraint(equalTo: guide.widthAnchor),
            drawImage.heightAnchor.constraint(equalTo: guide.heightAnchor),
            
            btnRestart.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            btnRestart.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        ])
    }
}

//MARK:- ACTIONS
extension ViewController{
    
    @objc
    func tap(sender:UITapGestureRecognizer){
        drawImage.image = UIImage()
        let touchPoint = sender.location(in: drawImage)
        print("tap at \(touchPoint)")
        drawPoint(point: touchPoint, color:UIColor.black)
        pointCloud += [touchPoint]
        
        mbr = MBR.compute(pointCloud)
        pointCloud.forEach{drawPoint(point: $0, color: .brown)}
        drawBox(box:mbr, color:UIColor.red)
        
        convexhull = ConvexHull().closedConvexHull(pointCloud)
        drawConvexHull(box: convexhull, color: .green)
    }
    
    @objc
    func restartTapped(sender:Any?){
        drawImage.image = UIImage()
        pointCloud = []
        mbr = []
        convexhull = []
    }
}

//MARK:- DRAW
extension ViewController{
    func drawPoint(point:CGPoint, color:UIColor){
        // 1
        UIGraphicsBeginImageContext(drawImage.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        drawImage.image?.draw(in:CGRect(x: 0,
                                        y: 0,
                                        width: drawImage.frame.size.width,
                                        height: drawImage.frame.size.height))
        
        // 2
        context.addRect(CGRect(origin: point, size: CGSize(width:2,height:2)))
        
        
        // 3
        context.setLineCap(.butt)
        context.setLineWidth(1.0)
        context.setStrokeColor(color.cgColor)
        context.setBlendMode(.normal)
        
        // 4
        context.strokePath()
        
        // 5
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        drawImage.alpha = 1.0
        UIGraphicsEndImageContext()
    }
    
    func drawBox(box:[CGPoint], color:UIColor){
        guard box.count >= 4 else{ return}
        
        // 1
        UIGraphicsBeginImageContext(drawImage.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        drawImage.image?.draw(in:CGRect(x: 0,
                                        y: 0,
                                        width: drawImage.frame.size.width,
                                        height: drawImage.frame.size.height))
        
        // 2
        context.move(to: box[0])
        context.addLine(to: box[1])
        context.addLine(to: box[2])
        context.addLine(to: box[3])
        context.addLine(to: box[0])
        
        // 3
        context.setLineCap(.butt)
        context.setLineWidth(1.0)
        context.setStrokeColor(color.cgColor)
        context.setBlendMode(.normal)
        
        // 4
        context.strokePath()
        
        // 5
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        drawImage.alpha = 1.0
        UIGraphicsEndImageContext()
    }
    
    func drawConvexHull(box:[CGPoint], color:UIColor){
        // 1
        UIGraphicsBeginImageContext(drawImage.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        drawImage.image?.draw(in:CGRect(x: 0,
                                        y: 0,
                                        width: drawImage.frame.size.width,
                                        height: drawImage.frame.size.height))
        
        // 2
        context.move(to: box[0])
        box[1..<box.endIndex].forEach{context.addLine(to: $0)}
        context.addLine(to: box[0])
        
        // 3
        context.setLineCap(.butt)
        context.setLineWidth(1.0)
        context.setStrokeColor(color.cgColor)
        context.setBlendMode(.normal)
        
        // 4
        context.strokePath()
        
        // 5
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        drawImage.alpha = 1.0
        UIGraphicsEndImageContext()
    }
}

