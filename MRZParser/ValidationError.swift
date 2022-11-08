//
//  ValidationError.swift
//  MRZParser
//
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

/// Enumeration which represents errors that can occur during MRZ validation process.
enum ValidationError: Error, Hashable {
  case invalidDocumentNumber
  case invalidFirstNames
  case invalidLastNames
  case invalidBirthDate
  case invalidNationality
  case invalidGender
}
