//
//  Int+Helpers.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 07/04/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import Foundation

extension Double {
    
    var msToSeconds: Double {
        Double(self) / 1000
    }
    
    var secondsToMiliseconds: Double {
        Double(self) * 1000
    }
}
