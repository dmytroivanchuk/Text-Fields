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

    //MARK: - validateNoDigits Tests
    
    func test_validateNoDigits_withInput_shouldReturnNoDigitsString() throws {
        let noDigitsString = inputValidationModel.validateNoDigits(in: "String with 123 digits")
        XCTAssertEqual(noDigitsString, "String with  digits")
    }
    
    //MARK: - validateInputLimit Tests
    
    func test_validateInputLimit_withOverflowInput_shouldSetPropertiesToTextFieldAndLabel() throws {
        let label = UILabel()
        let textField = UITextField()
        textField.text = "Long string with overflow"
        
        inputValidationModel.validateInputLimit(for: "Long string with overflow", in: textField, inputLimit: 10, showResultIn: label)
        
        
        textField.attributedText?.enumerateAttributes(in: NSRange(location: 10, length: textField.attributedText!.length - 10)) { (attributes, range, stop) in

            attributes.forEach { (key, value) in
                if key == NSAttributedString.Key.foregroundColor {
                    let overflowInputColor = value as? UIColor
                    XCTAssertEqual(overflowInputColor, UIColor(named: "redColor"))
                }
            }
        }
        
        XCTAssertEqual(label.text, "25/10")
        XCTAssertEqual(label.textColor, UIColor(named: "redColor"))
        XCTAssertEqual(textField.layer.borderWidth, 1)
        XCTAssertEqual(textField.layer.borderColor, UIColor(named: "redColor")?.cgColor)
    }
    
    func test_validateInputLimit_withNonOverflowInput_shouldSetPropertiesToTextFieldAndLabel() throws {
        let label = UILabel()
        let textField = UITextField()
        textField.text = "Short str"
        
        inputValidationModel.validateInputLimit(for: "Short str", in: textField, inputLimit: 10, showResultIn: label)
        
        XCTAssertEqual(label.text, "9/10")
        XCTAssertEqual(label.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(textField.layer.borderColor, UIColor(named: "blueColor")?.cgColor)
    }
    
    //MARK: - validateOnlyCharacters Tests
    
    func test_validateOnlyCharacters_with3Letters_shouldReturnMaskedString() throws {
        let textField = UITextField()
        textField.text = "str"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "i", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(isValidated)
    }
    
    func test_validateOnlyCharacters_with4Letters_shouldReturnMaskedStringPlusSeparator() throws {
        let textField = UITextField()
        textField.text = "stri"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "n", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(!isValidated)
        XCTAssertEqual(textField.text, "strin-")
    }
        
    func test_validateOnlyCharacters_with5Letters_shouldReturnMaskedStringPlusSeparator() throws {
        let textField = UITextField()
        textField.text = "strin"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "1", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(!isValidated)
        XCTAssertEqual(textField.text, "strin-")
    }
    
    func test_validateOnlyCharacters_with5LettersAndSeparator_shouldReturnMaskedString() throws {
        let textField = UITextField()
        textField.text = "strin-"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "1", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(isValidated)
    }
    
    func test_validateOnlyCharacters_withEmptyInput_shouldReturnNothing() throws {
        let textField = UITextField()
        textField.text = "strin-"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(isValidated)
    }
    
    func test_validateOnlyCharacters_with5LettersAnd5Digits_shouldReturnNothing() throws {
        let textField = UITextField()
        textField.text = "strin-12345"
        
        let isValidated = inputValidationModel.validateOnlyCharacters(for: "6", in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")
        XCTAssert(!isValidated)
        XCTAssertEqual(textField.text, "strin-12345")
    }
    
    //MARK: - validateLink Tests
    
    func test_validateLink_withValidInput_shouldReturnURL() throws {
        let url = inputValidationModel.validateLink(in: "https://foxminded.ua")
        XCTAssertEqual(url?.absoluteString, "https://foxminded.ua")
    }
    
    func test_validateLink_withInvalidInput_shouldReturnNil() throws {
        let url = inputValidationModel.validateLink(in: "http://")
        XCTAssertEqual(url?.absoluteString, nil)
    }
    
    //MARK: - validateValidationRules Tests
    
    func test_validateValidationRules_withAllConditions_shouldSetPropertiesToLabel() throws {
        let textField = UITextField()
        let label0 = UILabel()
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        
        label0.text = "Min length 8 characters."
        label1.text = "Min 1 digit,"
        label2.text = "Min 1 lowercase,"
        label3.text = "Min 1 capital required."
        
        
        inputValidationModel.validateValidationRules(in: "!@#$%^&*", for: textField, setValidationStateInLabels: [label0, label1, label2, label3])
        XCTAssert(label0.text!.contains("✓"))
        XCTAssert(!label1.text!.contains("✓"))
        XCTAssert(!label2.text!.contains("✓"))
        XCTAssert(!label3.text!.contains("✓"))
        XCTAssertEqual(label0.textColor, UIColor(named: "greenColor"))
        XCTAssertEqual(label1.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label2.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label3.textColor, UIColor(named: "blackColor"))
        
        
        inputValidationModel.validateValidationRules(in: "12345", for: textField, setValidationStateInLabels: [label0, label1, label2, label3])
        XCTAssert(!label0.text!.contains("✓"))
        XCTAssert(label1.text!.contains("✓"))
        XCTAssert(!label2.text!.contains("✓"))
        XCTAssert(!label3.text!.contains("✓"))
        XCTAssertEqual(label0.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label1.textColor, UIColor(named: "greenColor"))
        XCTAssertEqual(label2.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label3.textColor, UIColor(named: "blackColor"))
        
        
        inputValidationModel.validateValidationRules(in: "abcde", for: textField, setValidationStateInLabels: [label0, label1, label2, label3])
        XCTAssert(!label0.text!.contains("✓"))
        XCTAssert(!label1.text!.contains("✓"))
        XCTAssert(label2.text!.contains("✓"))
        XCTAssert(!label3.text!.contains("✓"))
        XCTAssertEqual(label0.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label1.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label2.textColor, UIColor(named: "greenColor"))
        XCTAssertEqual(label3.textColor, UIColor(named: "blackColor"))
        
        
        inputValidationModel.validateValidationRules(in: "ABCDE", for: textField, setValidationStateInLabels: [label0, label1, label2, label3])
        XCTAssert(!label0.text!.contains("✓"))
        XCTAssert(!label1.text!.contains("✓"))
        XCTAssert(!label2.text!.contains("✓"))
        XCTAssert(label3.text!.contains("✓"))
        XCTAssertEqual(label0.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label1.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label2.textColor, UIColor(named: "blackColor"))
        XCTAssertEqual(label3.textColor, UIColor(named: "greenColor"))
    }
}
