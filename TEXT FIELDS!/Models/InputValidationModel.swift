//
//  InputValidationModel.swift
//  TEXT FIELDS!
//
//  Created by Dmytro Ivanchuk on 03.08.2022.
//

import UIKit
import SafariServices

struct InputValidationModel {
    
    //MARK: - noDigitsFieldTextFieldView Validation Methods
    
    func validateNoDigits(in input: String) -> String {
        input.filter { !$0.isNumber }
    }
    
    //MARK: - inputLimitTextFieldView Validation Methods
    
    func validateInputLimit(for input: String, in textField: UITextField, inputLimit: Int, showResultIn label: UILabel) {
        label.text = "\(input.count)/\(inputLimit)"
        if input.count > inputLimit {
            let attributedText = NSMutableAttributedString(attributedString: textField.attributedText!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "redColor")!, range: NSRange(location: inputLimit, length: attributedText.length - inputLimit))
            textField.attributedText = attributedText
            
            label.textColor = UIColor(named: "redColor")
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(named: "redColor")?.cgColor
        } else {
            label.textColor = UIColor(named: "blackColor")
            textField.layer.borderColor = UIColor(named: "blueColor")?.cgColor
        }
    }
    
    //MARK: - onlyCharactersTextFieldView Validation Methods
    
    func validateOnlyCharacters(for input: String, in textField: UITextField, numberOfLetters: Int, numberOfDigits: Int, separator: String, lettersRegex: String, digitsRegex: String) -> Bool {
        if input.isEmpty {
            return true
        }

        if textField.text!.count < numberOfLetters {
            if inputContains(regex: lettersRegex, in: input) {
                if (textField.text! + input).count == numberOfLetters {
                    textField.text! += input + separator
                    return false
                }
                return true
            }
            
        } else if textField.text?.count == numberOfLetters {
            textField.text! += separator
            return false
        
        } else if textField.text!.count < numberOfLetters + numberOfDigits + separator.count {
            return inputContains(regex: digitsRegex, in: input)
        }

        return false
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
    
    //MARK: - validationRulesTextFieldView Validation Properties and Methods
    
    var validationCoefficient: Float = 0.0
    
    let coefficientToColorRelation: [Float : UIColor] = [
        0.25 : UIColor(named: "redColor")!,
        0.50 : UIColor(named: "orangeColor")!,
        0.75 : UIColor(named: "yellowColor")!,
        1.00 : UIColor(named: "greenColor")!
    ]
    
    mutating func validateValidationRules(in input: String, for textField: UITextField, setValidationStateInLabels labels: [UILabel]) {
        
        input.count >= 8 ? setValidationState(of: labels[0], isValidated: true) : setValidationState(of: labels[0], isValidated: false)

        inputContains(regex: ".*[0-9]+.*", in: input) ? setValidationState(of: labels[1], isValidated: true) : setValidationState(of: labels[1], isValidated: false)

        inputContains(regex: ".*[a-z]+.*", in: input) ? setValidationState(of: labels[2], isValidated: true) : setValidationState(of: labels[2], isValidated: false)

        inputContains(regex: ".*[A-Z]+.*", in: input) ? setValidationState(of: labels[3], isValidated: true) : setValidationState(of: labels[3], isValidated: false)
    }
    
    mutating func setValidationState(of label: UILabel, isValidated: Bool) {
        
        if isValidated {
            if !label.text!.contains("✓ ") {
                label.text = "✓ " + label.text!
            }
            label.textColor = UIColor(named: "greenColor")
            validationCoefficient += 0.25
            
        } else {
            label.text = label.text?.replacingOccurrences(of: "✓ ", with: "")
            label.textColor = UIColor(named: "blackColor")
        }
    }
    
    //MARK: - General Validation Methods
    
    func inputContains(regex: String, in input: String) -> Bool {
        let regexRule = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexRule.evaluate(with: input)
    }
}
