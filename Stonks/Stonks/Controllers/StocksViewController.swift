//
//  StocksViewController.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import UIKit


class StocksViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak fileprivate var companyLogoImageView: UIImageView!
    @IBOutlet weak fileprivate var companyNameLabel: UILabel!
    @IBOutlet weak fileprivate var companySymbolLabel: UILabel!
    @IBOutlet weak fileprivate var priceTitleLabel: UILabel!
    @IBOutlet weak fileprivate var priceLabel: UILabel!
    @IBOutlet weak fileprivate var priceChangedTitleLabel: UILabel!
    @IBOutlet weak fileprivate var priceChangeLabel: UILabel!
    @IBOutlet weak fileprivate var companyPickerView: UIPickerView!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak fileprivate var companyInfoStackView: UIStackView!
    
    fileprivate let companies = ["Apple": "AAPL",
                             "Microsoft": "MSFT",
                             "Google": "GOOG",
                             "Amazon": "AMZN",
                             "Facebook": "FB"]
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        revealPickerView()
        revealCompanyStackView()
    }
    
    // MARK: - Private Methods
    
    
}

// MARK: - UI Animation Methods

extension StocksViewController {
    /// Прячет интерфейс для анимации
    private func hideUI() {
        companyPickerView.alpha = 0.0
        companyInfoStackView.alpha = 0.0
    }
    
    /// Анимация появления PickerView
    private func revealPickerView() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.3,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.companyPickerView.alpha = 1.0
            },
            completion: nil)
    }
    
    /// Анимация появления CompanyStackView
    private func revealCompanyStackView() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.5,
            animations: { [weak self] in
                self?.companyInfoStackView.alpha = 1.0
            },
            completion: nil)
    }
}

// MARK: - UIPickerView Extensions

// MARK: UIPickerViewDataSource
extension StocksViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.keys.count
    }
}

// MARK: UIPickerViewDelegate
extension StocksViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies.keys)[row]
    }
    
    // Делаем чуть больше ширину между компонентами
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    // Создаем кастомный лейбл для пикера для изменения шрифта и цвета текста
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: 26)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = Array(companies.keys)[row]
        
        return label
    }
}
