//
//  Logics.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 07.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import Foundation
import Darwin

extension Array {
    public mutating func shuffle() {
        var temp = [Element]()
        while !isEmpty {
            let i = Int(arc4random_uniform(UInt32(count)))
            let obj = remove(at: i)
            temp.append(obj)
        }
        self = temp
    }
}

class Logics {
    
    let arrayForDivision = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
    let arrayForDivisionAnswer = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
    
    var taskText = ""
    var correctAnswer = 0
    
    func createRandomSum() -> [Int] {
        
        var arrayRandomSum: [Int] = []
        
        let randomOne = Int(arc4random_uniform(101))
        let randomTwo = Int(arc4random_uniform(101))
        
        correctAnswer = randomOne + randomTwo
        arrayRandomSum.append(correctAnswer)
        taskText = "\(String(randomOne)) + \(String(randomTwo)) = ?"
        
        var i = 0
        
        while (i <= 7) {
            let randomX = Int(arc4random_uniform(201))
            arrayRandomSum.append(randomX)
            i += 1
        }
        
        arrayRandomSum.shuffle()
        
        return arrayRandomSum
    }
    
    func createRandomDifference() -> [Int] {
        
        var arrayRandomDifference: [Int] = []
        
        var a = Int(arc4random_uniform(101))
        var b = Int(arc4random_uniform(101))
        
        repeat {
            a = Int(arc4random_uniform(101))
            b = Int(arc4random_uniform(101))
        } while (a <= b)
        
        correctAnswer = a - b
        arrayRandomDifference.append(correctAnswer)
        taskText = "\(String(a)) - \(String(b)) = ?"
        
        var i = 0
        
        while (i <= 7) {
            let randomX = Int(arc4random_uniform(100))
            arrayRandomDifference.append(randomX)
            i += 1
        }
        
        arrayRandomDifference.shuffle()
        
        return arrayRandomDifference
    }
    
    func createRandomMultiply() -> [Int] {
        
        var arrayRandomMultiply: [Int] = []
        
        let randomOne = Int(arc4random_uniform(101))
        let randomTwo = Int(arc4random_uniform(11))
        
        correctAnswer = randomOne * randomTwo
        arrayRandomMultiply.append(correctAnswer)
        taskText = "\(String(randomOne)) x \(String(randomTwo)) = ?"
        
        var i = 0
        
        while (i <= 7) {
            let randomX = Int(arc4random_uniform(1001))
            arrayRandomMultiply.append(randomX)
            i += 1
        }
        
        arrayRandomMultiply.shuffle()
        
        return arrayRandomMultiply
    }
    
    func createRandomDivision(array: [Int]) -> [Int] {
        
        var arrayRandomDivision: [Int] = []
        
        var a: Int
        var b: Int
        
        a = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
        b = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
        
        while (a % b != 0) {
            a = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
            b = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
            while (a == b) {
                a = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
                b = arrayForDivision[Int(arc4random_uniform(UInt32(arrayForDivision.count)))]
            }
        }
        
        correctAnswer = a / b
        arrayRandomDivision.append(correctAnswer)
        taskText = "\(String(a)) / \(String(b)) = ?"
        
        var i = 0
        
        while (i <= 7) {
            let randomX = arrayForDivisionAnswer[Int(arc4random_uniform(UInt32(arrayForDivisionAnswer.count)))]
            arrayRandomDivision.append(randomX)
            i += 1
        }
        
        arrayRandomDivision.shuffle()
        
        return arrayRandomDivision
    }
    
}
