//
//  DDSettingsTableViewController.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import UIKit

class DDSettingsTableViewController: DDTableViewController {
    
    @IBOutlet weak var flashCell: UITableViewCell!
    @IBOutlet weak var delayCell: UITableViewCell!
    @IBOutlet weak var exposeCell1: UITableViewCell!
    @IBOutlet weak var exposeCell2: UITableViewCell!
    @IBOutlet weak var exposeCell3: UITableViewCell!
    @IBOutlet weak var repetitionsCell: UITableViewCell!
    @IBOutlet weak var flashIntensitySlider: UISlider!
    
    private let label = UITextField()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.reloadParameterData()
    }
    
    private func reloadParameterData() {
        
        flashCell.detailTextLabel?.text = "\(DDParameterStore.shared.flashDuration)"
        delayCell.detailTextLabel?.text = "\(DDParameterStore.shared.delay)"
        exposeCell1.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime1)"
        exposeCell2.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime2)"
        exposeCell3.detailTextLabel?.text = "\(DDParameterStore.shared.exposeTime3)"
        repetitionsCell.detailTextLabel?.text = "\(DDParameterStore.shared.repetitions)"
        flashIntensitySlider.value = DDParameterStore.shared.flashIntensity
    }
    
    private func showInputPopup() {
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func didUpdateFlashIntensity(_ sender: Any) {
        
        guard let slider = sender as? UISlider else { return }
        DDParameterStore.shared.flashIntensity = slider.value
    }
}
