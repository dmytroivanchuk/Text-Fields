//
//  InputValidationModelUnitTests.swift
//  InputValidationModelUnitTests
//
//  Created by Dmytro Ivanchuk on 08.08.2022.
//

import XCTest
@testable import TEXT_FIELDS_

class InputValidationModelUnitTests: XCTestCase {

    var inputValidationModel: InputValidationModel!
    
    override func setUpWithError() throws {
        inputValidationModel = InputValidationModel()
    }

    override func tearDownWithError() throws {
        inputValidationModel = nil
    }
    
    func test_validateLink_withValidInput_shouldReturnURL() throws {
        let url = inputValidationModel.validateLink(in: "https://foxminded.ua")
        XCTAssertEqual(url?.absoluteString, "https://foxminded.ua")
    }
    
    func test_validateLink_withInvalidInput_shouldReturnNil() throws {
        let url = inputValidationModel.validateLink(in: "http://")
        XCTAssertEqual(url?.absoluteString, nil)
    }
    
    func test_inputContains_withInvalidInput_shouldReturnFalse() throws {
        let isDigitValidated = inputValidationModel.inputContains(regex: ".*[0-9]+.*", in: "!@#$%^&*")
        XCTAssert(!isDigitValidated)
        
        let isLowercaseValidated = inputValidationModel.inputContains(regex: ".*[a-z]+.*", in: "!@#$%^&*")
        XCTAssert(!isLowercaseValidated)
        
        let isUppercaseValidated = inputValidationModel.inputContains(regex: ".*[A-Z]+.*", in: "!@#$%^&*")
        XCTAssert(!isUppercaseValidated)
    }
    
    func test_inputContains_withValidInput_shouldReturnTrue() throws {
        let isDigitValidated = inputValidationModel.inputContains(regex: ".*[0-9]+.*", in: "Hello World 1")
        XCTAssert(isDigitValidated)
        
        let isLowercaseValidated = inputValidationModel.inputContains(regex: ".*[a-z]+.*", in: "HELLO WORLd 1")
        XCTAssert(isLowercaseValidated)
        
        let isUppercaseValidated = inputValidationModel.inputContains(regex: ".*[A-Z]+.*", in: "hello worlD 1")
        XCTAssert(isUppercaseValidated)
    }
}
