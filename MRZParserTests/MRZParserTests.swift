//
//  MRZParserTests.swift
//  MRZParserTests
//
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

import XCTest
@testable import MRZParser

final class MRZParserTests: XCTestCase {
  private lazy var dateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    return dateFormatter
  }()
  
  // should return nil when called on empty string
  func testEmptyString() {
    let sut = MrzInfo.create(from: "")
    XCTAssertNil(sut)
  }
  
  // should return nil when called on random string
  func testRandomString() {
    let string = """
    !@#^&*()!@#%^&*()!@#^&*()!@#%^
    @#^&*()!@#%^&*()!@#^&*()!@#%^!
    #^&*()!@#%^&*()!@#^&*()!@#%^!@
    """
    let sut = MrzInfo.create(from: string)
    XCTAssertNil(sut)
  }
  
  // should return valid MrzInfo when called on correct TD1 string
  func testTD1CorrectString() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408122F1204159NLD<<<<<<<<<<<6
    ERIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.firstNames, ["ANNA", "MARIA"])
    XCTAssertEqual(sut.lastNames, ["ERIKSSON"])
    XCTAssertEqual(sut.documentNumber, "D23145890")
    let birthDate = dateFormatter.string(from: sut.birthDate)
    XCTAssertEqual(birthDate, "12/8/74")
    XCTAssertEqual(sut.nationality, "NLD")
    XCTAssertEqual(sut.gender, .female)
    XCTAssertTrue(sut.validationErrors.isEmpty)
  }
  
  // should return invalid document number error when document number checksum is incorrect
  func testInvalidDocumentNumber() {
    let string = """
    I<NLDD231458908<<<<<<<<<<<<<<<
    7408122F1204159NLD<<<<<<<<<<<3
    ERIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidDocumentNumber])
  }

  // should return invalid last names error when last name contains digits
  func testInvalidLastNames() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408122F1204159NLD<<<<<<<<<<<6
    9RIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidLastNames])
  }
  
  // should return invalid first names error when first name contains digits
  func testInvalidFirstNames() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408122F1204159NLD<<<<<<<<<<<6
    ERIKSSON<<ANNA<MARI7<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidFirstNames])
  }
  
  // should return invalid birth date when birth date checksum is incorrect
  func testBirthDate() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408123F1204159NLD<<<<<<<<<<<9
    ERIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidBirthDate])
  }
  
  // should return invalid natioanlity when nationality containts filler in the center
  func testNationality() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408122F1204159N<D<<<<<<<<<<<6
    ERIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidNationality])
  }
  
  // should return invalid gender when gender is not recognized
  func testGender() {
    let string = """
    I<NLDD231458907<<<<<<<<<<<<<<<
    7408122Z1204159NLD<<<<<<<<<<<6
    ERIKSSON<<ANNA<MARIA<<<<<<<<<<
    """
    guard let sut = MrzInfo.create(from: string) else {
      XCTFail("expected to have MrzInfo")
      return
    }
    
    XCTAssertEqual(sut.validationErrors, [.invalidGender])
  }
}
