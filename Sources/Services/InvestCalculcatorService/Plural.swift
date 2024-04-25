//
//  Plural.swift
//
//
//  Created by user on 25.04.2024.
//

import Foundation

/// Вспомогательная структура для склонения существительных в множественном числе
enum Plural {
    
    // MARK: - Общие вспомогательные методы
    
    /// Замена `NSString.bok_pluralForm(ofNumber:form1:form2:form3:)`
    /// - Parameters:
    ///   - one: Существительное для чисел 1, 21, 31, ...
    ///   - few: Существительное для чисел 2...4, 22...24, 32...34, ...
    ///   - many: Существительное для чисел 0, 5...20, 25...30, 35...40, ...
    /// - Returns: Подходящий вариант склонения
    static func custom(
        number: Int,
        one: String,
        few: String,
        many: String
    ) -> String {
        let mod100 = abs(number % 100)
        let mod10 = mod100 % 10
        if 11...19 ~= mod100 { return many }
        if 2...4 ~= mod10 { return few }
        if mod10 == 1 { return one }
        return many
    }
    
    /// Фраза типа "`number` `phrase(number)`".
    /// Для использования с функциями типа `Plural.days`
    static func spaced(
        number: Int,
        phrase: (Int) -> String
    ) -> String {
        return Self.spaced(number: number, phrase: phrase(number))
    }
    
    /// Фраза типа "`number` `phrase`"
    static func spaced(
        number: Int,
        phrase: String
    ) -> String {
        return "\(number)\u{00a0}\(phrase)"
    }
    
    // MARK: - Переиспользуемые существительные
    
    /// Существительное "день" в склонении числа `number`
    static func days(number: Int) -> String {
        // TODO: - Localized "Days.Plural.1", "Days.Plural.2", "Days.Plural.5"
        return custom(
            number: number,
            one: Constants.daysOne,
            few: Constants.daysFew,
            many: Constants.daysMany
        )
    }
    
    /// Существительное "месяц" в склонении числа `number`
    static func months(number: Int) -> String {
        // TODO: - Localized "Plural.Months.One", "Plural.Months.Few", "Plural.Months.Many"
        return custom(
            number: number,
            one: Constants.monthsOne,
            few: Constants.monthsFew,
            many: Constants.monthsMany
        )
    }
    
    /// Существительное "операция" в склонении числа `number`
    static func operations(number: Int) -> String {
        // TODO: - Localized "Plural.Operations.One", "Plural.Operations.Few", "Plural.Operations.Many"
        return custom(
            number: number,
            one: Constants.operationsOne,
            few: Constants.operationsFew,
            many: Constants.operationsMany
        )
    }
    
    /// Существительное "продукт" в склонении числа `number`
    static func products(number: Int) -> String {
        // TODO: - Localized "Plural.Products.One", "Plural.Products.Few", "Plural.Products.Many"
        return custom(
            number: number,
            one: Constants.productsOne,
            few: Constants.productsFew,
            many: Constants.productsMany
        )
    }
    
    /// Существительное "год" в склонении числа `number`
    static func years(number: Int) -> String {
        // TODO: - Localized "Plural.Years.One", "Plural.Years.Few", "Plural.Years.Many"
        return custom(
            number: number,
            one: Constants.yearsOne,
            few: Constants.yearsFew,
            many: Constants.yearsMany
        )
    }
}

// MARK: - Constants

private enum Constants {
    static let daysOne = "день"
    static let daysFew = "дня"
    static let daysMany = "дней"
    
    static let monthsOne = "месяц"
    static let monthsFew = "месяца"
    static let monthsMany = "месяцев"
    
    static let operationsOne = "операция"
    static let operationsFew = "операции"
    static let operationsMany = "операций"
    
    static let productsOne = "продукт"
    static let productsFew = "продукта"
    static let productsMany = "продуктов"
    
    static let yearsOne = "год"
    static let yearsFew = "года"
    static let yearsMany = "лет"
}
