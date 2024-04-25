//
//  DateFormatterService.swift
//  
//
//  Created by user on 24.04.2024.
//

import Foundation

struct DateFormatterService {
    
    // MARK: - Properties
    
    enum Format: String {
        case yyyyMMddTHHmmssSSSSSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
        case ddEmptyMMMMEmptyyyyyEmptyHHmm = "dd MMMM yyyy, HH:mm"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    }
    
    // MARK: - Private properties
    
    private let dateFormatter = DateFormatter()
    
    // MARK: - Methods
    
    func convert(with string: String?, from: Format, to: Format) -> String? {
        guard let string = string else { return nil }
        
        dateFormatter.dateFormat = from.rawValue
        let date = dateFormatter.date(from: string)
        
        guard let date = date else { return nil }
        
        dateFormatter.dateFormat = to.rawValue
        dateFormatter.locale = Locale(identifier: "ru")
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func makeStringFromDate(date: Date, format: Format) -> String {
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
