//
//  Int+Helpers.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 07/04/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import Foundation

extension Float {
    
    var msToSeconds: Float {
        Float(self) / 1000
    }
    
    var secondsToMiliseconds: Float {
        Float(self) * 1000
    }
}

extension Double {
    
    var msToSeconds: Float {
        Float(self) / 1000
    }
    
    var secondsToMiliseconds: Float {
        Float(self) * 1000
    }
}
