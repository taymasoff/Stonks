//
//  SplashViewController.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import UIKit
import Network

/*
 Приветственный экран приложения.
 При загрузке, отображает логотип, название приложения и строку интересных фактов о фондовом рынке с анимацией набора текста. Следующий экран будет презентован автоматически, по истечению небольшого делея. Пользователь может скипнуть анимацию, свайпнув по экрану влево, тогда приложение прекратит анимацию и сразу перейдет к следующему экрану.
 Пока пользователь на этом экране, приложение мониторит интернет соединение, если его нет - всплывет предупреждение.
 */

final class SplashViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var didYouKnowLabel: UILabel!
    @IBOutlet weak fileprivate var factsLabel: UILabel!
    @IBOutlet weak fileprivate var tipLabel: UILabel!
    
    private var typewriterTask: DispatchWorkItem?
    private var userSeenTheTip = false
    
    let monitor = NWPathMonitor()
    
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
        
        factsLabel.text = SomeFacts.facts.randomElement()
        
        startMonitoringInternetConnection()
        animateNewsLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        stopMonitoringInternetConnection()
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
            typedText: factsLabel.text ?? "No facts today 🤷",
            characterDelay: 7) { [weak self] in
            
            self?.segueToStocks(delayedFor: 2)
        }
        
        if let task = typewriterTask {
            let queue = DispatchQueue(label: "newsLabelTyping",
                                      qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
}

// MARK: - Segue Methods

extension SplashViewController {
    
    /// Метод, выполняющий переход на экран Stocks
    private func segueToStocks() {
        // Отменяем задачу, на случай если пользователь скипнул анимацию и перешел на следующий экран, во избежании попытки повторного перехода
        typewriterTask?.cancel()
        performSegue(withIdentifier: Segues.toStocks, sender: self)
    }
    
    // Перегруженный метод перехода на следующий экран, добавляет задержку до перехода
    private func segueToStocks(delayedFor delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() +
                                        DispatchTimeInterval.seconds(delay)) { [weak self] in
            // Проверяем не была ли отменена задача
            guard let task = self?.typewriterTask, !task.isCancelled else { return }
            self?.performSegue(withIdentifier: Segues.toStocks, sender: self)
        }
    }
}

// MARK: - UIGestureRecognizer Methods

extension SplashViewController {
    
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

// MARK: - Network connection Monitoring

extension SplashViewController {
    
    /// Начинает мониторить интернет соединение
    private func startMonitoringInternetConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard path.status == .satisfied else {
                DispatchQueue.main.async {
                    self?.typewriterTask?.cancel()
                    self?.alert(message: "Автор не успел реализовать работу приложения в офлайне, поэтому, пожалуйста, включите интернет и перезапустите приложение", title: "🚫📶 Интернет тю-тю 😢")
                }
                self?.monitor.cancel()
                return
            }
        }
        
        let queue = DispatchQueue(label: "Network Monitor",
                                  qos: .utility)
        monitor.start(queue: queue)
    }
    
    /// Заканчивает мониторить интернет соединение
    private func stopMonitoringInternetConnection() {
        monitor.cancel()
    }
}
