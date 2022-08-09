//
//  ViewControllerUITests.swift
//  ViewControllerUITests
//
//  Created by Dmytro Ivanchuk on 08.08.2022.
//

import XCTest

class ViewControllerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_noDigitsTextField_withInput_shouldReturnNoDigitsText() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["noDigitsTextField"].tap()
        app.textFields["noDigitsTextField"].typeText("String with 123 and 456 digits")
        XCTAssertEqual(app.textFields["noDigitsTextField"].value as! String, "String with  and  digits")
    }
        
    func test_inputLimitTextField_withInput_shouldShowSpecifiedCharacterCounterLabel() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["inputLimitTextField"].tap()
        app.textFields["inputLimitTextField"].typeText("Long string with overflow characters")
        app.staticTexts["Only characters"].tap()
        app.textFields["inputLimitTextField"].tap()
        
        let input = NSAttributedString(string: app.textFields["inputLimitTextField"].value as! String)
        input.enumerateAttributes(in: NSRange(location: 10, length: 26)) { (attributes, range, stop) in

                    attributes.forEach { (key, value) in
                        if key == NSAttributedString.Key.foregroundColor {
                            let overflowInputColor = value as? UIColor
                            XCTAssertEqual(overflowInputColor, UIColor(named: "redColor"))
                        }
                    }
                }

        XCTAssertEqual(app.staticTexts["characterCounterLabel"].label, "36/10")
    }
        
    func test_onlyCharactersTextField_withInput_shouldReturnMaskedText() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["onlyCharactersTextField"].tap()
        app.textFields["onlyCharactersTextField"].typeText("!@#$%12345abcde-")
        app.keyboards.keys["delete"].tap()
        app.textFields["onlyCharactersTextField"].typeText("-!@#$%12345abcde")
        XCTAssertEqual(app.textFields["onlyCharactersTextField"].value as! String, "abcde-12345")
        
        app.textFields["onlyCharactersTextField"].press(forDuration: 2.0)
        app.menuItems["Select All"].staticTexts["Select All"].tap()
        app.keyboards.keys["delete"].tap()
        app.textFields["onlyCharactersTextField"].typeText("!@#$%12345abcde!@#$%12345abcde")
        app.staticTexts["Only characters"].tap()
        XCTAssertEqual(app.textFields["onlyCharactersTextField"].value as! String, "abcde-12345")
    }
        
    func test_linkTextField_withInput_shouldPresentDetectedLink() throws {
        
        func testLink(withFormat format: String) {
            let app = XCUIApplication()
            app.launch()
            
            app.textFields["linkTextField"].tap()
            app.textFields["linkTextField"].typeText(format + "google.com")
            sleep(2)
            
            let safariURL = app.otherElements["URL"].value as! String
            XCTAssert(safariURL.contains("google.com"))
        }
        
        testLink(withFormat: "http://")
        testLink(withFormat: "www.")
    }
        
    func test_validationRulesTextField_withInput_shouldShowValidationStatus() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["validationRulesTextField"].tap()
        app.textFields["validationRulesTextField"].typeText("Hello World 24")
        
        XCTAssert(app.staticTexts["✓ Min length 8 characters."].exists)
        XCTAssert(app.staticTexts["✓ Min 1 digit,"].exists)
        XCTAssert(app.staticTexts["✓ Min 1 lowercase,"].exists)
        XCTAssert(app.staticTexts["✓ Min 1 capital required."].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
