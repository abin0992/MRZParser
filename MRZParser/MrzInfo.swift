//
//  MrzInfo.swift
//  MRZParser
//
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

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
    // TODO: Add your code here
    return nil
  }
}
