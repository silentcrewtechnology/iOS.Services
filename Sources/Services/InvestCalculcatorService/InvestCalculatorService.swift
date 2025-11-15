//
//  InvestCalculatorService.swift
//
//
//  Created by user on 25.04.2024.
//

import Foundation

public struct InvestCalculatorService {
    
    // MARK: - Methods
    
    public func calculateSum(amount: Decimal, bond: QuotationListBondViewModel) -> Decimal {
        let count = (amount / bond.price).rounded(scale: 0, roundingMode: .down)
        let finalSum = count * 10
        let yearSum = finalSum * bond.yieldToMaturity
        let daySum = yearSum / Constants.daysInYear
        let countDay = getCountDays(endDateString: bond.maturityDate)
        let profit = daySum * Decimal(countDay)
        
        return profit.rounded(scale: 0, roundingMode: .down)
    }
    
    public func getCountDays(endDateString: String) -> Int {
        let endDates = endDateString.components(separatedBy: "T").first
        let date = Date()
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let endDates = endDates,
              let endDate = dateFormatter.date(from: endDates) else { return 0 }
        
        let components = calendar.dateComponents([.day], from: date, to: endDate)
        
        return components.value(for: .day) ?? 0
    }
    
    public func getTheTimeDifference(endDateString: String) -> String {
        let endDates = endDateString.components(separatedBy: "T").first
        let date = Date()
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let endDates = endDates,
              let endDate = dateFormatter.date(from: endDates) else { return "" }
        
        let components = calendar.dateComponents([.year, .month], from: date, to: endDate)
        
        let years = components.value(for: .year) ?? 0
        let months = components.value(for: .month) ?? 0
        
        let yearsTitle = pluralizedYears(years: years)
        let monthsTitle = pluralizedMonths(months: months)
        if years == 0, months == 0 {
            // TODO: - Localized "Invest.QuotationList.CalculateBonds.InvestPeriod.ThroughMonth"
            return Constants.monthLater
        }
        
        // TODO: - Localized "Invest.QuotationList.CalculateBonds.InvestPeriod.Through"
        return "Через \(yearsTitle)\(monthsTitle)"
    }
    
    public func pluralizedMonths(months: Int) -> String {
        guard months != 0 else { return "" }
        
        return " \(Plural.spaced(number: months, phrase: Plural.months))"
    }
    
    public func pluralizedYears(years: Int) -> String {
        guard years != 0 else { return "" }
        
        return " \(Plural.spaced(number: years, phrase: Plural.years))"
    }
}

// MARK: - Constants

private enum Constants {
    static let daysInYear: Decimal = 365
    static let monthLater = "Через месяц"
}

// MARK: - Decimal extension

private extension Decimal {
    func rounded(scale: Int, roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result: Decimal = 0
        var original = self
        NSDecimalRound(&result, &original, scale, roundingMode)
        
        return result
    }
}
