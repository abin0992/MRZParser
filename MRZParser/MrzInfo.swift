//
//  MrzInfo.swift
//  MRZParser
//
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

// MARK: - MrzInfo

/// Class which contains data extracted from machine readable zone (MRZ)
/// as well as a list with validation errors if there are any or empty list.
final class MrzInfo {
    /// Document number
    let documentNumber: String
    /// First names
    let firstNames: [String]
    /// Last names
    let lastNames: [String]
    /// Birth date
    let birthDate: Date
    /// Nationality
    let nationality: String
    /// Gender
    let gender: Gender
    /// Set with errors occurred during MRZ validation process or an empty set.
    let validationErrors: Set<ValidationError>

    init(
        documentNumber: String,
        firstNames: [String],
        lastNames: [String],
        birthDate: Date,
        nationality: String,
        gender: Gender,
        validationErrors: Set<ValidationError>
    ) {
        self.documentNumber = documentNumber
        self.firstNames = firstNames
        self.lastNames = lastNames
        self.birthDate = birthDate
        self.nationality = nationality
        self.gender = gender
        self.validationErrors = validationErrors
    }
}

extension MrzInfo {
    /// Creates a concrete instance of `MrzInfo` from the provided string.
    /// - Note: returns `nil` in case of malformed string.
    static func create(from string: String) -> MrzInfo? {
        
        let mrzLines: [String] = string.components(separatedBy: "\n")

        guard mrzLines.count == 3 else {
            return nil
        }

        let (firstLine, secondLine, thirdLine) = (mrzLines[0], mrzLines[1], mrzLines[2])

        let formatter: MRZFieldFormatter = MRZFieldFormatter()

        // MARK: Line #1

        let documentNumber: MRZField = formatter.format(
            fieldType: .documentNumber,
            from: firstLine,
            at: 5,
            length: 9,
            checkDigitFollows: true
        )

        // MARK: Line #2

        let birthDateField: MRZField = formatter.format(
            fieldType: .birthDate,
            from: secondLine,
            at: 0,
            length: 6,
            checkDigitFollows: true
        )

        let genderField: MRZField = formatter.format(
            fieldType: .gender,
            from: secondLine,
            at: 7,
            length: 1
        )

        let nationality: MRZField = formatter.format(
            fieldType: .nationality,
            from: secondLine,
            at: 15,
            length: 3
        )

        // MARK: Line #3

        let lastNames: MRZField = formatter.format(
            fieldType: .lastNames,
            from: thirdLine,
            at: 0,
            length: 29
        )

        let firstNames: MRZField = formatter.format(
            fieldType: .firstNames,
            from: thirdLine,
            at: 0,
            length: 29
        )

        var validationErrors = Set<ValidationError>()

        if let documentNumberIsValid = documentNumber.isValid,
           !documentNumberIsValid
        {
            validationErrors.insert(ValidationError.invalidDocumentNumber)
        }

        if lastNames.value == nil {
            validationErrors.insert(ValidationError.invalidLastNames)
        }

        if firstNames.value == nil {
            validationErrors.insert(ValidationError.invalidFirstNames)
        }

        if let birthDateIsValid = birthDateField.isValid,
           !birthDateIsValid
        {
            validationErrors.insert(ValidationError.invalidBirthDate)
        }

        if genderField.value == nil {
            validationErrors.insert(ValidationError.invalidGender)
        }

        if !(nationality.rawValue.containsOnlyLetters && nationality.rawValue.count == 3) {
            validationErrors.insert(ValidationError.invalidNationality)
        }

        let surnames: [String] = lastNames.value as? [String] ?? []
        let givenNames: [String] = firstNames.value as? [String] ?? []
        let gender: Gender = genderField.value as? Gender ?? .unknown

        if let birthDate = birthDateField.value as? Date {
            return MrzInfo(
                documentNumber: documentNumber.rawValue,
                firstNames: givenNames,
                lastNames: surnames,
                birthDate: birthDate,
                nationality: nationality.rawValue,
                gender: gender,
                validationErrors: validationErrors
            )
        }

        return nil
    }
}
