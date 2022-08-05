//
//  ViewController.swift
//  TEXT FIELDS!
//
//  Created by Dmytro Ivanchuk on 01.08.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    var inputValidationModel = InputValidationModel()
    var sfSafariViewController: SFSafariViewController?
    var timer = Timer()
    
    var titleLabel = UILabel()
    
    var textFieldViewStackView = UIStackView()
    var noDigitsFieldTextFieldView = createCustomTextFieldView(text: "NO digits field", placeholder: "Type here")
    var inputLimitTextFieldView = createCustomTextFieldView(text: "Input limit", placeholder: "Type here")
    var onlyCharactersTextFieldView = createCustomTextFieldView(text: "Only characters", placeholder: "wwwww-ddddd")
    var linkTextFieldView = createCustomTextFieldView(text: "Link", placeholder: "www.example.com")
    var validationRulesTextFieldView = createCustomTextFieldView(text: "Validation rules", placeholder: "Password")
    
    var characterCounterLabel = UILabel()
    
    var validationProgressView = UIProgressView()
    
    var labelStackView = UIStackView()
    var lengthValidationLabel = createCustomLabel(text: "Min length 8 characters.")
    var digitValidationLabel = createCustomLabel(text: "Min 1 digit,")
    var lowercaseValidationLabel = createCustomLabel(text: "Min 1 lowercase,")
    var uppercaseValidationLabel = createCustomLabel(text: "Min 1 capital required.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        configureTextFieldViewStackView()
        configureCharacterCounterLabel()
        configureValidationProgressView()
        configureLabelStackView()
        
        noDigitsFieldTextFieldView.inputTextField.delegate = self
        inputLimitTextFieldView.inputTextField.delegate = self
        onlyCharactersTextFieldView.inputTextField.delegate = self
        linkTextFieldView.inputTextField.delegate = self
        validationRulesTextFieldView.inputTextField.delegate = self
        
        noDigitsFieldTextFieldView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        inputLimitTextFieldView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        onlyCharactersTextFieldView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        linkTextFieldView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        validationRulesTextFieldView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - UIElements Property and Layout Configuration Methods
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Text Fields"
        titleLabel.textColor = UIColor(named: "blackColor")
        titleLabel.font = UIFont(name: "Rubik-Medium", size: 34)
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 92 / 812, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 16 / 375, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 359 / 375, constant: 0).isActive = true
    }
    
    func configureTextFieldViewStackView() {
        view.addSubview(textFieldViewStackView)
        textFieldViewStackView.axis = .vertical
        textFieldViewStackView.distribution = .equalSpacing
        
        textFieldViewStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: textFieldViewStackView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 163 / 812, constant: 0).isActive = true
        textFieldViewStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 426 / 812).isActive = true
        textFieldViewStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        textFieldViewStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        textFieldViewStackView.addArrangedSubview(noDigitsFieldTextFieldView)
        textFieldViewStackView.addArrangedSubview(inputLimitTextFieldView)
        textFieldViewStackView.addArrangedSubview(onlyCharactersTextFieldView)
        textFieldViewStackView.addArrangedSubview(linkTextFieldView)
        textFieldViewStackView.addArrangedSubview(validationRulesTextFieldView)
    }
    
    func configureCharacterCounterLabel() {
        view.addSubview(characterCounterLabel)
        characterCounterLabel.text = "0/10"
        characterCounterLabel.textColor = UIColor(named: "blackColor")
        characterCounterLabel.font = UIFont(name: "Rubik-Regular", size: 13)
        
        characterCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCounterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        characterCounterLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        NSLayoutConstraint(item: characterCounterLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 248 / 812, constant: 0).isActive = true
        
    }
    
    func configureValidationProgressView() {
        view.addSubview(validationProgressView)
        validationProgressView.trackTintColor = .clear
        validationProgressView.progressViewStyle = .bar
        
        validationProgressView.translatesAutoresizingMaskIntoConstraints = false
        validationProgressView.topAnchor.constraint(equalTo: textFieldViewStackView.bottomAnchor, constant: -6).isActive = true
        validationProgressView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        validationProgressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        validationProgressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0).isActive = true
    }
    
    func configureLabelStackView() {
        view.addSubview(labelStackView)
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.topAnchor.constraint(equalTo: textFieldViewStackView.bottomAnchor, constant: 15).isActive = true
        labelStackView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        NSLayoutConstraint(item: labelStackView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 24 / 375, constant: 0).isActive = true
        NSLayoutConstraint(item: labelStackView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 351 / 375, constant: 0).isActive = true
        
        labelStackView.addArrangedSubview(lengthValidationLabel)
        labelStackView.addArrangedSubview(digitValidationLabel)
        labelStackView.addArrangedSubview(lowercaseValidationLabel)
        labelStackView.addArrangedSubview(uppercaseValidationLabel)
        
    }
    
    //MARK: - Default UIElements Creation Methods
    
    static func createCustomTextFieldView(text: String, placeholder: String) -> TextFieldView {
        let textFieldView = Bundle(for: TextFieldView.self).loadNibNamed("\(TextFieldView.self)", owner: self)![0] as? TextFieldView
        textFieldView?.textFieldLabel.text = text
        textFieldView?.inputTextField.placeholder = placeholder
        return textFieldView!
    }
    
    static func createCustomLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "blackColor")
        label.font = UIFont(name: "Rubik-Regular", size: 13)
        return label
    }
    
    //MARK: - Keyboard Handling Methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if validationRulesTextFieldView.inputTextField.isEditing {
                self.view.frame.origin.y = 0 - keyboardSize.height
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

//MARK: - UITextField Methods

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        deselectTextFields(ignoring: textField)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let input = textField.text {
            
            switch textField {
            
            case noDigitsFieldTextFieldView.inputTextField:
                textField.text = inputValidationModel.validateNoDigits(in: input)
            
            case inputLimitTextFieldView.inputTextField:
                inputValidationModel.validateInputLimit(for: input, in: textField, inputLimit: 10, showResultIn: characterCounterLabel)
                
            case linkTextFieldView.inputTextField:
                timer.invalidate()
                
                if let url = inputValidationModel.validateLink(in: input) {
                    timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                        
                        if !input.hasPrefix("http://") && !input.hasPrefix("https://") {
                            self.presentDetectedLink(url: self.inputValidationModel.validateLink(in: "http://" + input)!)
                        } else {
                            self.presentDetectedLink(url: url)
                        }
                    }
                }
            
            case validationRulesTextFieldView.inputTextField:
                validationRulesTextFieldView.inputTextField.isSecureTextEntry = true
                inputValidationModel.validateValidationRules(in: input, for: textField, setValidationStateInLabels: [lengthValidationLabel, digitValidationLabel, lowercaseValidationLabel, uppercaseValidationLabel])
                validationProgressView.progress = inputValidationModel.validationCoefficient
                validationProgressView.progressTintColor = inputValidationModel.coefficientToColorRelation[inputValidationModel.validationCoefficient]
                inputValidationModel.validationCoefficient = 0
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        
        case onlyCharactersTextFieldView.inputTextField:
            return inputValidationModel.validateOnlyCharacters(for: string, in: textField, numberOfLetters: 5, numberOfDigits: 5, separator: "-", lettersRegex: "[A-Za-z]", digitsRegex: "[0-9]")

        default:
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        deselectTextFields()
    }
    
    func deselectTextFields(ignoring textField: UITextField? = nil) {
        let textFields = [
            noDigitsFieldTextFieldView.inputTextField,
            inputLimitTextFieldView.inputTextField,
            onlyCharactersTextFieldView.inputTextField,
            linkTextFieldView.inputTextField,
            validationRulesTextFieldView.inputTextField
        ]
        
        for tF in textFields.filter({ $0 != textField }) {
            tF.endEditing(true)
            if tF.layer.borderColor == UIColor(named: "redColor")?.cgColor {
                continue
            }
            tF.layer.borderWidth = 0
        }
        
        guard textField?.layer.borderColor != UIColor(named: "redColor")?.cgColor else {
            return
        }
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = UIColor(named: "blueColor")?.cgColor
    }
}

//MARK: - SFSafariViewController Methods

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentDetectedLink(url: URL) {
        sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController!.delegate = self
        self.present(sfSafariViewController!, animated: true, completion: nil)
    }
}
