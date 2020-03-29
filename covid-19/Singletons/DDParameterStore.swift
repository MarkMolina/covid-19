//
//  DDParameterStore.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import Foundation

class DDParameterStore {
    
    static let shared = DDParameterStore()
    
    var flashDuration = 600
    var delay = 30
    var exposeTime1 = 100
    var exposeTime2 = 100
    var exposeTime3 = 100
    var repetitions = 1000
    var flashIntensity: Float = 1.0 {
        didSet {
            print("Did update intesity to: \(oldValue)")
        }
    }
}
