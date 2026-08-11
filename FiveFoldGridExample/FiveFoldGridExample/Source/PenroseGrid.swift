//
//  PenroseGrid.swift
//  SinterPixelsBridge
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation
import SinterAppleEvents
import SinterPixels

public class PenroseGrid   {
    var axisPaths: [Int: [NSAppleEventDescriptor]]
    let app: SPApp
    public init(app: SPApp) {
        axisPaths = [:]
        self.app = app
    }
    
    func makeABSequence() -> [Int] {
        var a = 1.0
        var b = 1.0
        let gr = 1.618
        var abList = [0, 1]
        for _ in 0...43 {
            if (a / b > gr) {
                abList.append(1)
                b += 1.0
            } else {
                abList.append(0)
                a += 1.0
            }
        }
        return abList
    }
    
    public func makeLine( doc: SPDocument, ang: Double, pos: SPRadialCoordinates, col: SPColor) -> NSAppleEventDescriptor? {
        let rads = ang * 3.1416 / 180
         
        let props = SAERecord()
        let pos1 = SPRadialCoordinates(radius: 600.0, angle: rads + 3.1416)
        let a1 = SPAnchorData(tangent: ang, position: pos1)
        let pos2 = SPRadialCoordinates(radius: 600.0, angle: rads)
        let a2 = SPAnchorData(tangent: ang, position: pos2)
        let anchorList = NSAppleEventDescriptor.list()
        let fillColor = SPBColor(r:1.0, g:1.0, b:1.0, a:0.0)
        anchorList.insert(a1.asNSAppleEventDescriptor(), at: 1)
        anchorList.insert(a2.asNSAppleEventDescriptor(), at: 2)
        props.setKey(.pAnchorData, descriptor: anchorList)
        props.setKey(.pLineWidth, double: 1.5)
        props.setKey(.pFillColor, descriptor: fillColor.asNSAppleEventDescriptor())
        props.setKey(.pColor, descriptor: col.asNSAppleEventDescriptor())
        props.setKey(.pPosition, descriptor: pos.asNSAppleEventDescriptor())
        return doc.make(new: SPPath.fcc, props: props)
    }
    
    public func setColor(objects: [NSAppleEventDescriptor], col: SPColor) {
        for object in objects {
            let saeObject = SAEObject(app: app, objSpec: object)
            let colorProp = saeObject.property(FourCharCode.pColor)
            colorProp?.setData(newValue: col.asNSAppleEventDescriptor())
        }
    }
    
    public func party(on doc: NSAppleEventDescriptor) {
        makeBackgroundLines(in: doc)
        
        var newAlpha = 0.99
        while newAlpha > 0.2 {
            let spcolor = SPBColor(r: 1.0, g: 0.5, b: 0.5, a: newAlpha)
            for n in 0...4 {
                if let lines = axisPaths[n] {
                    setColor(objects: lines, col: spcolor)
                }
            }
            newAlpha = newAlpha - 0.1
        }
    }
    
    public func makeBackgroundLines(in doc: NSAppleEventDescriptor) {
        let spDoc = SPDocument(app: app, objSpec: doc)
        let abList = makeABSequence()
        let angleList = [0.0, 72.0, 144.0, 216.0, 288.0]
        let origin = SPRadialCoordinates(radius: 0.0, angle: 0.0)

        var axis = 0
        for nthAngle in angleList {
            let rads = nthAngle * 3.1416 / 180.0
            let myColor = SPHSBColor(h:0.0, s:0.9, b:0.9)
            var currentRadius = 0.0
            var nthPaths: [NSAppleEventDescriptor?] = []
            var path = makeLine(doc: spDoc, ang: nthAngle, pos: origin, col: myColor)
            nthPaths.append(path)
            var increment: Double
            for aorb in abList {
                let incr = 9.0
                if aorb == 0 {
                    increment = incr * 1.618
                } else {
                    increment = incr
                }
                currentRadius += increment
                let posa = SPRadialCoordinates(radius:currentRadius, angle:rads + (0.5 * 3.1416))
                let posb = SPRadialCoordinates(radius:currentRadius, angle:rads + (1.5 * 3.1416))
                
                path = makeLine(doc: spDoc, ang: nthAngle, pos: posa, col: myColor)
                nthPaths.append(path)
                path = makeLine(doc: spDoc, ang: nthAngle, pos: posb, col: myColor)
                nthPaths.append(path)
            }
            axisPaths[axis] = nthPaths.compactMap { $0 }
            axis += 1
        }
 
    }
}
