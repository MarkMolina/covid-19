//
//  DDSettingsTableViewController.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import UIKit

class DDSettingsTableViewController: DDTableViewController {
    
    var exposureMinMax: (min: Float, max: Float)!
    
    @IBOutlet weak var flashCell: UITableViewCell!
    @IBOutlet weak var delayCell: UITableViewCell!
    @IBOutlet weak var exposeCell1: UITableViewCell!
    @IBOutlet weak var exposeCell2: UITableViewCell!
    @IBOutlet weak var exposeCell3: UITableViewCell!
    @IBOutlet weak var repetitionsCell: UITableViewCell!
    @IBOutlet weak var flashIntensitySlider: UISlider!
    @IBOutlet weak var exposureSlider: UISlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.FlashDurationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.DelayChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.ExposeTime1Changed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.ExposeTime2Changed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.ExposeTime3Changed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.RepetitionsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParameterData), name: DDParameterStore.FlashIntensityChanged, object: nil)
        
        exposureSlider.minimumValue = exposureMinMax.min
        exposureSlider.maximumValue = exposureMinMax.max
        exposureSlider.value = DDParameterStore.shared.exposeTime1
        
        self.reloadParameterData()
    }
    
    @objc private func reloadParameterData() {
        
        flashCell.detailTextLabel?.text = "\(DDParameterStore.shared.flashDuration)"
        delayCell.detailTextLabel?.text = "\(DDParameterStore.shared.delay)"
        exposeCell1.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime1)"
        exposeCell2.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime2)"
        exposeCell3.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime3)"
        repetitionsCell.detailTextLabel?.text = "\(DDParameterStore.shared.repetitions)"
        flashIntensitySlider.value = DDParameterStore.shared.flashIntensity
        exposureSlider.value = DDParameterStore.shared.exposeTime1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let p = parameter(forIndex: indexPath.row, inSection: indexPath.section)
        let popupVC = DDInputPopupViewController(value: p) { [weak self] (newValue) in
            self?.set(parameter: newValue, forIndex: indexPath.row, inSection: indexPath.section)
        }
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction private func didUpdateFlashIntensity(_ sender: Any) {
        
        guard let slider = sender as? UISlider else { return }
        DDParameterStore.shared.flashIntensity = slider.value
    }
    
    @IBAction private func didUpdateExposure(_ sender: Any) {
        
        guard let slider = sender as? UISlider else { return }
        DDParameterStore.shared.exposeTime1 = slider.value
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

fileprivate extension DDSettingsTableViewController {
    
    // MARK: GET
    
    private func parameter(forIndex: Int, inSection: Int) -> Double {
        
        switch inSection {
            case 0: return timingParameter(forIndex: forIndex)
            case 1: return additionalParameter(forIndex: forIndex)
            default: return 0
        }
    }
        
    private func timingParameter(forIndex: Int) -> Double {
        
        switch forIndex {
            case 0: return DDParameterStore.shared.flashDuration
            case 1: return DDParameterStore.shared.delay
            case 3: return Double(DDParameterStore.shared.exposeTime1)
            case 4: return DDParameterStore.shared.exposeTime2
            case 5: return DDParameterStore.shared.exposeTime3
            default: return 0
        }
        
    }
    
    private func additionalParameter(forIndex: Int) -> Double {
        
        switch forIndex {
            case 0: return Double(DDParameterStore.shared.repetitions)
            case 1: return Double(DDParameterStore.shared.flashIntensity)
            default: return 0
        }
    }
    
    // MARK: SET
    
    private func set(parameter: Double, forIndex: Int, inSection: Int) {
    
        switch inSection {
            case 0: set(timingParameter: parameter, forIndex: forIndex)
            case 1: set(additionalParameter: parameter, forIndex: forIndex)
        default: break
        }
    }
    
    private func set(timingParameter: Double, forIndex: Int) {
        
        switch forIndex {
            case 0: DDParameterStore.shared.flashDuration = timingParameter
            case 1: DDParameterStore.shared.delay = timingParameter
            case 3:
                let p = Float(timingParameter)
                if p > exposureMinMax.max {
                    DDParameterStore.shared.exposeTime1 = exposureMinMax.max
                } else if p < exposureMinMax.min {
                    DDParameterStore.shared.exposeTime1 = exposureMinMax.min
                } else {
                    DDParameterStore.shared.exposeTime1 = Float(timingParameter)
                }
            case 4: DDParameterStore.shared.exposeTime2 = timingParameter
            case 5: DDParameterStore.shared.exposeTime3 = timingParameter
            default: break
        }
    }
    
    private func set(additionalParameter: Double, forIndex: Int) {
        
        switch forIndex {
            case 0:  DDParameterStore.shared.repetitions = Int(additionalParameter)
            case 1:  DDParameterStore.shared.flashIntensity = Float(additionalParameter)
            default: break
        }
    }
}
