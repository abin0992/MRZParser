//
//  MRZFieldFormatter.swift
//  MRZParser
//
//  Created by Abin Baby on 11.11.22.
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

import Foundation

class MRZFieldFormatter {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    func format(
        fieldType: MRZFieldType,
        from string: String,
        at startIndex: Int,
        length: Int,
        checkDigitFollows: Bool = false
    ) -> MRZField {
        let endIndex: Int = (startIndex + length)
        let rawValue: String = string.substring(from: startIndex, to: endIndex - 1)
        let checkDigit: String? = checkDigitFollows ? string.substring(from: endIndex, to: endIndex) : nil
        
        return MRZField(
            value: format(string: rawValue, as: fieldType),
            rawValue: rawValue,
            checkDigit: checkDigit
        )
    }
    
    private func format(string: String, as fieldType: MRZFieldType) -> Any? {
        switch fieldType {
        case .firstNames:
            return firstNames(from: string)
        case .lastNames:
            return lastNames(from: string)
        case .birthDate:
            return birthdate(from: string)
        case .gender:
            return sex(from: string)
        default:
            return text(from: string)
        }
    }
    
    // MARK: Value Formatters

    private func firstNames(from string: String) -> [String]? {
        let identifiers: [String] = string.trimmingFillers
            .components(separatedBy: "<<")
            .map { $0.replace(target: "<", with: " ") }
        
        var secondaryID: [String] = []
        
        if identifiers.indices.contains(1) {
            secondaryID = identifiers[1].components(separatedBy: " ")
            for name in secondaryID {
                guard name.containsOnlyLetters else {
                    return nil
                }
            }
        }
        return secondaryID
    }
    
    private func lastNames(from string: String) -> [String]? {
        let identifiers: [String] = string.trimmingFillers
            .components(separatedBy: "<<")
            .map { $0.replace(target: "<", with: " ") }
        
        var primaryID: [String] = []
        if identifiers.indices.contains(1) {
            primaryID = identifiers[0].components(separatedBy: " ")
            for name in primaryID {
                guard name.containsOnlyLetters else {
                    return nil
                }
            }
        }
        return primaryID
    }
    
    private func sex(from string: String) -> Gender? {
        switch string {
        case "M":
            return .male
        case "F":
            return .female
        case "<":
            return .unknown
        default:
            return nil
        }
    }
    
    private func birthdate(from string: String) -> Date? {
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return nil
        }

        let calendar: Calendar = Calendar(identifier: .gregorian)
        let currentYear: Int = calendar.component(.year, from: Date()) - 2000
        let parsedYear: Int = Int(string.substring(from: 0, to: 1))!
        let centennial: String = (parsedYear > currentYear) ? "19" : "20"
        
        return dateFormatter.date(from: centennial + string)
    }
    
    private func text(from string: String) -> String {
        string.trimmingFillers.replace(target: "<", with: " ")
    }
}
