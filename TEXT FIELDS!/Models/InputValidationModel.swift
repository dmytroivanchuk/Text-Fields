//
//  InputValidationModel.swift
//  TEXT FIELDS!
//
//  Created by Dmytro Ivanchuk on 03.08.2022.
//

import UIKit
import SafariServices

struct InputValidationModel {
    
    func inputContains(regex: String, in input: String) -> Bool {
        let regexRule = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexRule.evaluate(with: input)
    }
    
    //MARK: - linkTextFieldView Validation Methods
    
    func validateLink(in input: String) -> URL? {
        
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let detectedURL = dataDetector.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)),
           let urlRange = Range(detectedURL.range, in: input),
           let url = URL(string: String(input[urlRange])) {
            return url
        } else {
            return nil
        }
    }
    
    //MARK: - validationRulesTextFieldView Validation Properties
    
    var validationCoefficient: Float = 0.0
    
    let coefficientToColorRelation: [Float : UIColor] = [
        0.25 : UIColor(named: "redColor")!,
        0.50 : UIColor(named: "orangeColor")!,
        0.75 : UIColor(named: "yellowColor")!,
        1.00 : UIColor(named: "greenColor")!
    ]
}
