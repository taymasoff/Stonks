//
//  Constants.swift
//  Stonks
//
//  Created by Тимур Таймасов on 03.09.2021.
//

import Foundation

/// Список констант на все идентификаторы переходов между экранами в приложении
enum Segues {
    static let toStocks = "toStocksViewController"
}

/// Список констант, необходимых для нетворк запросов
enum API {
    static let token = "pk_221b199b9b0c45e8a38aa9c32f4359bc"
}

/// Массив интересных фактов про фондовый рынок, для вывода на приветственном экране
struct SomeFacts {
    static let facts =
        ["In November 2020, total market capitalization reached a record $95 trillion, surpassing pre-coronavirus levels.",
         "There are 19 stock exchanges in the world with a market capitalization of more than $1 trillion.",
         "Middle-class households have lost more than half of household equity holdings since 1989.",
         "About 10% of US households hold international equity.",
         "Stock market declines of 5% to 10% generally require a month’s recovery time.",
         "The current US bull market is ten years old and counting.",
         "In 2018, the United States represented 40.01% of global market capitalization. In 2020, this figure rose to 54.5%.",
         "On average, stock market corrections happen once every two years.",
         "Valued at $2.25 trillion, Apple leads the world’s corporations in market capitalization.",
         "With a 27.6% market share, the information technology sector leads the US stock market in market capitalization.",
         "More than 80% of the stock market is now automated.",
         "Share repurchases return to the $200 billion range in the first quarter of 2020.",
         "Corrections are least likely in the third year of a presidential term.",
         "The stock market usually performs the worst in September.",
         "Since 1903, every day at the New York Stock Exchange starts with the ringing of a bell at 9:30 a.m.",
         "The most expensive stock in the world is Warren Buffet’s Berkshire Hathaway.",
         "Established in 1602, the Amsterdam Stock Exchange was the first in the world.",
         "Changes in stock prices were expressed as fractions until the year 2000.",
         "Australia has had the best performing share market in the world from 1900 to 2009.",
         "Women first worked on the New York Stock Exchange in 1943 due to a shortage of male workers during World War II."]
}
