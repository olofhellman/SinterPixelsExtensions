//
//  SPScript.swift
//  SinterPixelsBridge
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation
import SinterAppleEvents
import SinterPixels

public class SPScript {
    public func run() async {
        if let spApp = SPApp() {
            let _ = spApp.activate()
            if let firstDoc = spApp.document(atASIndex:1) {
                print("doc: \(firstDoc)  ")
            }
            
            let props = SAERecord()
            props.setKey(.pHeight, int: 1000) 
            props.setKey(.pWidth, int: 1000) 
            
            if let madeObject = spApp.make(new: SPDocument.fcc, container: NSAppleEventDescriptor.null(), props: props)
            {
                print("event result: \(String(describing: madeObject)))")
                let pg = PenroseGrid(app: spApp)
                pg.party(on: madeObject)
            }
        }
    }
}
