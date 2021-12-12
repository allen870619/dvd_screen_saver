//
//  DVDCreator.swift
//  dvdPlayerDemo
//
//  Created by Lee Yen Lin on 2021/12/12.
//

import UIKit

class DVDCreator{
    let dvd = UIImage(named: "dvd")!
    let srcWidth = UIScreen.main.bounds.width
    let srcHeight = UIScreen.main.bounds.height
    let mainView: UIView!
    
    // data
    let ratio: Double = 75
    let numTotal = 1
    let betweenEachTime: Double = 0.2
    var isBreak = false
    var shiftData: [(dx: CGFloat, dy: CGFloat, sx: CGFloat, sy: CGFloat)] = [] // d: distance, s: speed
    var desireRange: ClosedRange<Double>!
    
    init(_ view: UIView) {
        mainView = view
        desireRange = (1 * ratio)...(4 * ratio)
    }
    
    func createDVD(){
        for i in stride(from: 0, to: Double(numTotal) * betweenEachTime, by: betweenEachTime){
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i)){
                self.initOne()
            }
        }
    }
    
    func initOne(){
        let index = shiftData.count
        let img = DVDImage(image: dvd)
        img.frame = CGRect(x: 0, y: 0, width: 108, height: 64)
        img.center = CGPoint(x: mainView.frame.width / 2, y: mainView.frame.height / 2)
        mainView.addSubview(img)
        shiftData.append((0, 0, randSpd(), randSpd()))
        calRoute(img, index)
    }
    
    func randSpd() -> CGFloat{
        let neg = Int.random(in: 0...1) == 1
        return Double.random(in: desireRange) * (neg ? -1 : 1)
    }
    
    func calRoute(_ img: DVDImage, _ index: Int){
        var t = 0.0
        /* img color*/
        img.image = dvd.withTintColor(UIColor(red: Double.random(in: 0.5...1), green: Double.random(in: 0.5...1), blue: Double.random(in: 0.5...1), alpha: 1))
        
        /* speed*/
        // x
        if abs(img.mx - mainView.frame.width) < 0.1{
            shiftData[index].sx = -Double.random(in: desireRange)
        }else if img.x < 0.1{
            shiftData[index].sx = Double.random(in: desireRange)
        }
        
        // y
        if abs(img.my - mainView.frame.height) < 0.1{
            shiftData[index].sy = -Double.random(in: desireRange)
        }else if img.y < 0.1{
            shiftData[index].sy = Double.random(in: desireRange)
        }
        
        /* distance*/
        // x
        if shiftData[index].sx > 0{
            shiftData[index].dx = srcWidth - img.mx
        }else{
            shiftData[index].dx = -img.x
        }
        
        // y
        if shiftData[index].sy > 0{
            shiftData[index].dy = mainView.frame.height - img.my
        }else{
            shiftData[index].dy = -(img.y)
        }
        
        // time, choose faster
        t = min(shiftData[index].dx / shiftData[index].sx, shiftData[index].dy / shiftData[index].sy)
        let route = img.frame.offsetBy(dx: t * shiftData[index].sx, dy: t * shiftData[index].sy)
        
        // animate
        UIView.animate(withDuration: t, delay: 0, options: .curveLinear){
            img.frame = route
        }completion: {[self] _ in
            if !isBreak{
                calRoute(img, index)
            }
        }
    }
}

class DVDImage: UIImageView{
    var x: CGFloat{
        get{
            return frame.minX
        }
    }
    
    var mx: CGFloat{
        get{
            return frame.maxX
        }
    }
    
    var y: CGFloat{
        get{
            return frame.minY
        }
    }
    
    var my: CGFloat{
        get{
            return frame.maxY
        }
    }
}
