//
//  Extensions.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import UIKit

typealias FinishedTyping = () -> ()

// MARK: - UIViewController

extension UIViewController {
    // MARK: - Alert Manager
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UILabel

extension UILabel {
    
    // MARK: - Typewriter animation
    
    /// Функция, создающая анимацию в виде набора печатного текста
    /// - Parameters:
    ///   - typedText: вводимый текст
    ///   - characterDelay: задержка ввода (чем меньше, тем быстрее)
    func setTextWithTypeAnimation(typedText: String,
                                  characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
    /// Функция, создающая анимацию в виде набора печатного текста (с колбеком)
    /// - Parameters:
    ///   - typedText: вводимый текст
    ///   - characterDelay: задержка ввода (чем меньше, тем быстрее)
    ///   - completed: колбек о завершении операции
    func setTextWithTypeAnimation(typedText: String,
                                  characterDelay: TimeInterval = 5.0,
                                  completed: @escaping FinishedTyping) -> DispatchWorkItem {
        text = ""
        
        let task = DispatchWorkItem {
            [weak self] in
            for character in typedText {
                DispatchQueue.main.async {
                    self?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
            completed()
        }
        
        return task
    }
}
