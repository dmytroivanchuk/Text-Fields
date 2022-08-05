//
//  TextField.swift
//  TEXT FIELDS!
//
//  Created by Dmytro Ivanchuk on 01.08.2022.
//

import UIKit

class TextFieldView: UIView {
    
    var textFieldLabel = UILabel()
    var inputTextField = UITextField()
    var stackView = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextFieldLabel()
        configureInputTextField()
        configureStackView()
    }
    
    func configureTextFieldLabel() {
        textFieldLabel.text = "Type here"
        textFieldLabel.textColor = UIColor(named: "blackColor")
        textFieldLabel.font = UIFont(name: "Rubik-Regular", size: 13)
        
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configureInputTextField() {
        inputTextField.placeholder = "Type here"
        inputTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        inputTextField.layer.cornerRadius = 10
        inputTextField.backgroundColor = UIColor(named: "grayColor")
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func configureStackView() {
        addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        stackView.addArrangedSubview(textFieldLabel)
        stackView.addArrangedSubview(inputTextField)
    }
}
