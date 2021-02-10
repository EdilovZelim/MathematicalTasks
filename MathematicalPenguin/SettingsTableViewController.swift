//
//  SettingsTableViewController.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 18.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var selectSound: UISegmentedControl!
    
    var userSettings = UserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil) //убираем тайтл в кнопке "назад"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.title = NSLocalizedString("Settings", comment: "")
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
//        selectSound.tintColor = UIColor(red: 255 / 255, green: 188 / 255, blue: 103 / 255, alpha: 1.0)
        
        rateBtn.clipsToBounds = true
        rateBtn.layer.cornerRadius = 3.0
        rateBtn.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userSettings.loadUserSettings()
        
        if userSettings.audio == 0 {
            selectSound.selectedSegmentIndex = 0
        } else {
            selectSound.selectedSegmentIndex = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = UIColor(red: 69 / 255, green: 92 / 255, blue: 123 / 255, alpha: 1.0)
            view.textLabel?.textColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
        }
    }
    
    
    @IBAction func statusAudio(_ sender: UISegmentedControl) {
        
        switch selectSound.selectedSegmentIndex {
        case 0:
            userSettings.audio = 0
            userSettings.saveUserSettings()
        case 1:
            userSettings.audio = 1
            userSettings.saveUserSettings()
        default:
            break
        }
        
    }

    @IBAction func rateApp(_ sender: UIButton) {
        if let url = URL(string: "https://itunes.apple.com/app/id") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
