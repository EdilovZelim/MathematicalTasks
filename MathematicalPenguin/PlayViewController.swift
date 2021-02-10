//
//  PlayViewController.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 06.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import UIKit
import Darwin
import AudioToolbox
import AVFoundation

class PlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var rewardTitle: UIBarButtonItem!
    @IBOutlet weak var starItem: UIBarButtonItem!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userSettings = UserSettings()
    
    var logics = Logics()
    
    var scoreReward = 0
    var selectTask = 0
    var correctAnswer = 0
    var arrayNumbers: [Int] = []
    
    private var timer = Timer()
    private let timeInterval = 2.0
    
    var counterTest = 0
    
    var player: AVAudioPlayer?
    
    var statusAudio = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil) //убираем тайтл в кнопке "назад"
        
        if selectTask == 5 {
            self.navigationItem.title = "\(counterTest) / 20"
        }

        userSettings.loadUserSettings()
        
        scoreReward = userSettings.reward
        statusAudio = userSettings.audio
        rewardTitle.title = String(scoreReward)
        rewardTitle.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
        starItem.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
        
        taskLabel.clipsToBounds = true
        taskLabel.layer.cornerRadius = 16
        taskLabel.layer.borderWidth = 0
        taskLabel.layer.borderColor = UIColor(red: 255 / 255, green: 188 / 255, blue: 103 / 255, alpha: 1.0).cgColor
        
        customCollectionView()
        
        play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playCollectionViewCell", for: indexPath) as! PlayCollectionViewCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor(red: 255 / 255, green: 188 / 255, blue: 103 / 255, alpha: 1.0).cgColor
        
        cell.numberInCell.text = String(arrayNumbers[indexPath.row])
        
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
            return CGSize(width: (screenWidth - 60) / 3, height: (screenWidth - 60) / 3)
        } else {
            print("iPad")
            return CGSize(width: (screenWidth - 80) / 3, height: (screenWidth - 80) / 3)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PlayCollectionViewCell
        
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * .pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        let colorCorrectAnswer = UIColor(red: 160 / 255, green: 192 / 255, blue: 60 / 255, alpha: 1.0)
        let colorWrongAnswer = UIColor(red: 255 / 255, green: 100 / 255, blue: 68 / 255, alpha: 1.0)
        
        if cell.numberInCell.text == String(logics.correctAnswer) {
            
            cell.layer.transform = rotationTransform
            cell.backgroundColor = colorCorrectAnswer
            
            // возвращаем ячейки в исходное положение
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
            
            collectionView.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
                self.taskLabel.text = NSLocalizedString("Correct answer! :)", comment: "")
            })
            
            playSoundCorrectAnswer()
            
            addStar()
            
            correctAnswer += 1
            
            if selectTask == 5 {
                addCounterTest()
            }
            
            if counterTest == 20 {
                alertTestComplete()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: {_ in
                    self.play()
                    cell.backgroundColor = UIColor.white
                    collectionView.isUserInteractionEnabled = true
                })
            }
            
        } else {
            
            cell.layer.transform = rotationTransform
            cell.backgroundColor = colorWrongAnswer
            
            // возвращаем ячейки в исходное положение
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
            
            collectionView.isUserInteractionEnabled = false
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
                self.taskLabel.text = NSLocalizedString("Incorrect answer! Correct answer: ", comment: "") + String(self.logics.correctAnswer)
            })
            
            if selectTask == 5 {
                addCounterTest()
            }
            
            if counterTest == 20 {
                alertTestComplete()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in
                    self.play()
                    cell.backgroundColor = UIColor.white
                    collectionView.isUserInteractionEnabled = true
                })
            }
        }
    }
    
    func play() {
        
        func random() {
            
            let i = Int(arc4random_uniform(4))
            
            switch i {
            case 0:
                arrayNumbers = logics.createRandomSum()
            case 1:
                arrayNumbers = logics.createRandomDifference()
            case 2:
                arrayNumbers = logics.createRandomMultiply()
            case 3:
                arrayNumbers = logics.createRandomDivision(array: logics.arrayForDivision)
            default:
                break
            }
            
        }
        
        switch selectTask {
        case 0:
            arrayNumbers = logics.createRandomSum()
        case 1:
            arrayNumbers = logics.createRandomDifference()
        case 2:
            arrayNumbers = logics.createRandomMultiply()
        case 3:
            arrayNumbers = logics.createRandomDivision(array: logics.arrayForDivision)
        case 4:
            random()
        case 5:
            random()
        default:
            break
        }
        
        taskLabel.text = logics.taskText
        collectionView.reloadData()
        
    }
    
    func addStar() {
        scoreReward += 1
        
        userSettings.reward = scoreReward
        userSettings.saveUserSettings()
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.rewardTitle.title = String(self.scoreReward)
            self.rewardTitle.tintColor = UIColor(red: 255 / 255, green: 100 / 255, blue: 68 / 255, alpha: 1.0)
            self.starItem.tintColor = UIColor(red: 255 / 255, green: 100 / 255, blue: 68 / 255, alpha: 1.0)
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: {_ in
            self.starItem.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
            self.rewardTitle.tintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1.0)
        })
        
    }
    
    func addCounterTest() {
        
        counterTest += 1
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.navigationItem.title = "\(self.counterTest) / 20"
        })
        
    }
    
    func alertTestComplete() {
        
        let alertController = UIAlertController(title: NSLocalizedString("The test is completed!", comment: ""), message: NSLocalizedString("Number of correct answers: ", comment: "") + "\(correctAnswer) / 20", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Home", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            
            self.nextView()
            
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            
            let result = NSLocalizedString("I finished the test. Number of correct answers: ", comment: "") + "\(self.correctAnswer) / 20"
            
            let url = URL(string: "https://itunes.apple.com/app/id1128065487")
            let activityVC = UIActivityViewController(activityItems: [result, url!], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            activityVC.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
                UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")]
            
            self.present(activityVC, animated: true, completion: nil)
            
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func nextView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(viewController, animated: true, completion: nil)
    }

}
