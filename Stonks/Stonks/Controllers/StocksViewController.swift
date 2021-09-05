//
//  StocksViewController.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import UIKit


class StocksViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak fileprivate var companyLogoImageView: UIImageView!
    @IBOutlet weak fileprivate var companyNameLabel: UILabel!
    @IBOutlet weak fileprivate var companySymbolLabel: UILabel!
    @IBOutlet weak fileprivate var priceTitleLabel: UILabel!
    @IBOutlet weak fileprivate var priceLabel: UILabel!
    @IBOutlet weak fileprivate var priceChangedTitleLabel: UILabel!
    @IBOutlet weak fileprivate var priceChangeLabel: UILabel! {
        didSet {
            changePriceChangeLabelColor()
        }
    }
    @IBOutlet weak fileprivate var companyPickerView: UIPickerView!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak fileprivate var companyInfoStackView: UIStackView!
    
    // MARK: - Private Properties
    
    /// Список "растущих" компаний
    fileprivate var companies: [Company] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        
        updateCompaniesList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideUI()
        hidePickerView()
    }
    
    // MARK: - Private Methods
    
}

// MARK: - UI Manipulations

extension StocksViewController {
    
    /// Обновляет значения всех элементов UI
    /// - Parameter company: информацию какой компании выводить на экран
    private func updateUI(with company: Company) {
        companyNameLabel.text = company.companyName
        companySymbolLabel.text = company.symbol
        priceLabel.text = "\(company.latestPrice)"
        priceChangeLabel.text = "\(company.change)"
        
        revealUIAnimation()
    }
    
    /// Обновляет логотип на лого компании
    /// - Parameter logo: ссылка на логотип
    private func updateLogo(with logo: Logo) {
        companyLogoImageView.image = UIImage(data: logo.logo)
    }
    
    /// Измененяет цвет графы изменение цены
    private func changePriceChangeLabelColor() {
        guard let value = Double(priceChangeLabel.text ?? "") else {
            return
        }
        if (value > 0) {
            priceChangeLabel.textColor = .systemGreen
        } else if (value < 0) {
            priceChangeLabel.textColor = .systemRed
        } else {
            priceChangeLabel.textColor = .white
        }
    }
}

// MARK: - Network-Related Methods

extension StocksViewController {
    
    /// Обновляет список компаний в PickerView
    private func updateCompaniesList() {
        activityIndicator.startAnimating()
        
        let networkManager = NetworkManager()
        var request: Request {
            return StockRequests.companies
        }
        
        networkManager.perform(request: request) { (result: Result<[Company], Error>) in
            switch result {
            case .success(let companies):
                self.activityIndicator.stopAnimating()
                self.companies = companies
                self.requestCompanyUpdate()
                self.revealPickerViewAnimation()
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    /// Обновляет информацию о компании
    private func requestCompanyUpdate() {
        hideUI()
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        requestStock(for: companies[selectedRow])
        requestLogoURL(for: companies[selectedRow])
    }
    
    /// Запрашивает URL логотипа компании
    /// - Parameter company: компания
    private func requestLogoURL(for company: Company) {
        let networkManager = NetworkManager()
        var request: Request {
            return StockRequests.companyLogoURL(symbol: company.symbol)
        }
        
        networkManager.perform(request: request) { (result: Result<LogoURL, Error>) in
            switch result {
            case .success(let logoURL):
                self.requestLogoUpdate(with: logoURL.url)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    /// Запрашивает и загружает логотип по заданному URL
    ///  !!! Некоторые компании не имеют логотипа в наличии на сервере, вместо них стоит затычка
    /// - Parameter url: URL логотипа
    private func requestLogoUpdate(with url: String) {
        guard !url.isEmpty else {
            return companyLogoImageView.image = UIImage(named: "NoLogo")
        }
        
        let networkManager = NetworkManager()
        var request: Request {
            return StockRequests.companyLogo(fullPath: url)
        }
        
        networkManager.perform(request: request) { (result: Result<Logo, Error>) in
            switch result {
            case .success(let logo):
                self.updateLogo(with: logo)
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    /// Запрашивает обновленную инфу о компании
    /// - Parameter company: компания
    private func requestStock(for company: Company) {
        activityIndicator.startAnimating()
        
        let networkManager = NetworkManager()
        var request: Request {
            return StockRequests.companyStock(symbol: company.symbol)
        }
        
        networkManager.perform(request: request) { (result: Result<Company, Error>) in
            switch result {
            case .success(let company):
                self.activityIndicator.stopAnimating()
                self.updateUI(with: company)
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

// MARK: - UI Animation Methods

extension StocksViewController {
    /// Прячет интерфейс для анимации
    private func hideUI() {
        companyInfoStackView.alpha = 0.0
    }
    
    /// Прячет pickerView
    private func hidePickerView() {
        companyPickerView.alpha = 0.0
        companyPickerView.isUserInteractionEnabled = false
    }
    
    /// Анимация появления PickerView
    private func revealPickerViewAnimation() {
        companyPickerView.isUserInteractionEnabled = true
        companyPickerView.reloadAllComponents()
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.companyPickerView.alpha = 1.0
            },
            completion: nil)
    }
    
    /// Анимация появления CompanyStackView
    private func revealUIAnimation() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
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
        return companies.count
    }
}

// MARK: UIPickerViewDelegate
extension StocksViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return companies[row].companyName
    }
    
    // Делаем чуть больше ширину между компонентами
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    // Создаем кастомный лейбл для пикера для изменения шрифта и цвета текста
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont(name: "Montserrat", size: 22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = companies[row].companyName
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Запрашиваем обновленную инфу для выбранной компании
        requestCompanyUpdate()
    }
}
