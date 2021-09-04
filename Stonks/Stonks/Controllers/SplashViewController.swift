//
//  SplashViewController.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import UIKit

/*
 Приветственный экран приложения.
 При загрузке, отображает логотип, название приложения и строку интересных фактов о фондовом рынке с анимацией набора текста. Следующий экран будет презентован автоматически, по истечению небольшого делея. Пользователь может скипнуть анимацию, свайпнув по экрану влево, тогда приложение прекратит анимацию и сразу перейдет к следующему экрану.
 */

class SplashViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var didYouKnowLabel: UILabel!
    @IBOutlet weak fileprivate var factsLabel: UILabel!
    @IBOutlet weak fileprivate var tipLabel: UILabel!
    
    private var typewriterTask: DispatchWorkItem?
    private var userSeenTheTip = false
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tipLabel.alpha = 0.0
        
        setupGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkIfUserSeenTheTip()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateNewsLabel()
    }
    
    // MARK: - Private Methods
    
    /// Метод, проверяющий, использовал ли пользователь подсказку на экране
    private func checkIfUserSeenTheTip() {
        userSeenTheTip = UserDefaults.standard.bool(forKey: "usedTip")
        if !userSeenTheTip {
            showTheTip()
        }
    }
    
    /// Метод, отображающий подсказку, в случае если пользователь ее не видел
    private func showTheTip() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.5,
            animations: { [weak self] in
                self?.tipLabel.alpha = 1.0
            },
            completion: nil)
    }
    
    /// Метод, создающий задачу анимации набора текста для лейбла с новостями
    private func animateNewsLabel() {
        typewriterTask = factsLabel.setTextWithTypeAnimation(
            typedText: SomeFacts.facts.randomElement() ?? "No facts today 🤷",
            characterDelay: 6) { [weak self] in
        
            // По завершению анимации ждем полторы секунды и переходим на экран Stocks
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Проверяем не была ли отменена задача
                guard let task = self?.typewriterTask, !task.isCancelled else { return }
                self?.segueToStocks()
            }
        }
        
        if let task = typewriterTask {
            let queue = DispatchQueue(label: "newsLabelTyping",
                                      qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
    // MARK: - Segue Methods
    
    /// Метод, выполняющий переход на экран Stocks
    private func segueToStocks() {
        // Отменяем задачу, на случай если пользователь скипнул анимацию и перешел на следующий экран, во избежании попытки повторного перехода
        typewriterTask?.cancel()
        performSegue(withIdentifier: Segues.toStocks, sender: self)
    }
    
    // MARK: - UIGestureRecognizer Methods
    
    /// Метод, добавляющий считыватель жестов на родительский view
    func setupGestureRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(didSwipeLeft(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    /// Метод, вызывающийся при регистрации свайпа влево
    /// - Parameter sender: sender
    @objc private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if !userSeenTheTip {
            UserDefaults.standard.set(true, forKey: "usedTip")
        }
        segueToStocks()
    }
}
    
