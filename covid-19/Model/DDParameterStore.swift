//
//  DDParameterStore.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import Foundation

final class DDParameterStore {
    
    static let shared = DDParameterStore()
    
    var flashDuration = 600.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.FlashDurationChanged, object: nil)
        }
    }
    
    var delay = 30.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.DelayChanged, object: nil)
        }
    }
    
    var exposeTime1 = 100.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.ExposeTime1Changed, object: nil)
        }
    }
    
    var exposeTime2 = 100.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.ExposeTime2Changed, object: nil)
        }
    }
    
    var exposeTime3 = 100.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.ExposeTime3Changed, object: nil)
        }
    }
    
    var repetitions = 1000 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.RepetitionsChanged, object: nil)
        }
    }
    
    var flashIntensity: Float = 1.0 {
        didSet {
            NotificationCenter.default.post(name: DDParameterStore.FlashIntensityChanged, object: nil)
        }
    }
}

extension DDParameterStore {
    
    static let FlashDurationChanged = Notification.Name("flashDurationChanged")
    static let DelayChanged = Notification.Name("DelayChanged")
    static let ExposeTime1Changed = Notification.Name("ExposeTime1Changed")
    static let ExposeTime2Changed = Notification.Name("ExposeTime2Changed")
    static let ExposeTime3Changed = Notification.Name("ExposeTime3Changed")
    static let RepetitionsChanged = Notification.Name("repetitionsChanged")
    static let FlashIntensityChanged = Notification.Name("flashIntensityChanged")
}
