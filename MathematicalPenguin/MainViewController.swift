//
//  ViewController.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 04.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import UIKit
import StoreKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rewardTitle: UIBarButtonItem!
    @IBOutlet weak var starItem: UIBarButtonItem!
    
    var mainArrayCollection = ["плюс.png", "минус.png", "умножение.png", "деление.png", "block_4.png", "block_5.png"]
    
    var userSettings = UserSettings()
    
    var scoreReward = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
//        rewardTitle.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
//        starItem.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
        
        userSettings.loadUserSettings()
        userSettings.startApp += 1
        //userSettings.reward += 40
        userSettings.saveUserSettings()
        
        customCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // скрываем бордер в NavBar
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        userSettings.loadUserSettings()
        
        scoreReward = userSettings.reward
        rewardTitle.title = String(scoreReward)
        
        if scoreReward < 40 {
            mainArrayCollection[5] = "block_5_lock.png"
        } else {
            mainArrayCollection[5] = "block_5.png"
        }
        
        collectionView.reloadData()
        
        switch userSettings.startApp {
        case 5:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        case 15:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainArrayCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        
        cell.backgroundImage.image = UIImage(named: mainArrayCollection[indexPath.row])
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 16
        
        if cell.backgroundImage.image == UIImage(named: "block_5_lock.png") {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        return cell
        
    }
    
    // отступы ячеек коллекции
    func customCollectionView() {
        
        // Screen width.
        var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        // Screen height.
        var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if screenWidth < 768 { // iPhone
            layout.minimumLineSpacing = 15
            layout.sectionInset.left = 15
            layout.sectionInset.right = 15
            layout.sectionInset.top = 15
        } else { // iPad
            layout.minimumLineSpacing = 20
            layout.sectionInset.left = 20
            layout.sectionInset.right = 20
            layout.sectionInset.top = 20
        }
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Screen width.
        var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        // Screen height.
        var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        
        if screenWidth < 768 {
            print("iPhone")
            return CGSize(width: (screenWidth - 45) / 2, height: (screenWidth - 45) / 2)
        } else {
            print("iPad")
            return CGSize(width: (screenWidth - 80) / 3, height: (screenWidth - 80) / 3)
        }
        
    }
    
    // анимация ячеек
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * .pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        cell.layer.transform = rotationTransform
        
        // возвращаем ячейки в исходное положение
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: .curveEaseOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPlay" {
            let destinationVC = segue.destination as! PlayViewController
            let iPath = self.collectionView.indexPathsForSelectedItems
            let indexPath: NSIndexPath = iPath![0] as NSIndexPath
            let rowIndex = indexPath.row
            destinationVC.selectTask = rowIndex
            
            if rowIndex == 5 {
                scoreReward = scoreReward - 40
                
                userSettings.reward = scoreReward
                userSettings.saveUserSettings()
                
                UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
                    self.rewardTitle.title = String(self.scoreReward)
                    self.rewardTitle.tintColor = UIColor(red: 255 / 255, green: 100 / 255, blue: 68 / 255, alpha: 1.0)
                    self.starItem.tintColor = UIColor(red: 255 / 255, green: 100 / 255, blue: 68 / 255, alpha: 1.0)
                })
            }
        }
    }

}

