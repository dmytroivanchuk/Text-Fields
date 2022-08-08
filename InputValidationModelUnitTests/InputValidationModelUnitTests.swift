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

    func test_validateNoDigits_withString_shouldReturnNoDigitsString() throws {
        let noDigitsString = inputValidationModel.validateNoDigits(in: "String with 123 digits")
        XCTAssertEqual(noDigitsString, "String with  digits")
    }
}
