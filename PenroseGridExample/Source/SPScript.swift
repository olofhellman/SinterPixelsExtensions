//
//  SPScript.swift
//  SinterPixelsBridge
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation
import SinterPixels

public class SPScript {
    public func run() async {
        if let spApp = SPApp() {
            spApp.activate()
            if let firstDoc = spApp.document(atASIndex:1) {
                print("doc: \(firstDoc)  ")
            }
            let props = NSAppleEventDescriptor.record()
            props.setParam(NSAppleEventDescriptor(int32:1000), forKeyword: FourCharCode.pHeight)
            props.setParam(NSAppleEventDescriptor(int32:1000), forKeyword: FourCharCode.pWidth)
            if let madeObject = spApp.make(new: SPDocument.fcc, container: NSAppleEventDescriptor.null(), props: props)
            {
                print("event result: \(String(describing: madeObject)))")
                let pg = PenroseGrid()
                pg.party(on: madeObject)
            }
        }
    }
}
