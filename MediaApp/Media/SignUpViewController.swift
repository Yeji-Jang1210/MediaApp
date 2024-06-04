//
//  SignUpViewController.swift
//  MediaApp
//
//  Created by 장예지 on 6/4/24.
//

import UIKit
import SnapKit

class SignUpViewController: MediaViewController {
    
//MARK: objects
    let titleLabel: UILabel = {
        let object = UILabel()
        object.textColor = .red
        object.text = "YEJIFLIX"
        object.textAlignment = .center
        object.font = .systemFont(ofSize: 40, weight: .heavy)
        return object
    }()
    
    let textFieldStackView: UIStackView = {
        let object = UIStackView()
        object.axis = .vertical
        object.spacing = 12
        object.alignment = .fill
        object.distribution = .fillEqually
        return object
    }()
    
    let emailTextField: SignUpTextField = {
        let object = SignUpTextField()
        object.placeholder = SignUpLocalized.emailTextField.rawValue
        return object
    }()
    
    let pwdTextField: SignUpTextField = {
        let object = SignUpTextField()
        object.placeholder = SignUpLocalized.passwordTextField.rawValue
        return object
    }()
    
    let nicknameTextField: SignUpTextField = {
        let object = SignUpTextField()
        object.placeholder = SignUpLocalized.nicknameTextField.rawValue
        return object
    }()
    
    let addressTextField: SignUpTextField = {
        let object = SignUpTextField()
        object.placeholder = SignUpLocalized.addressTextField.rawValue
        return object
    }()
    
    let recomentCodeTextField: SignUpTextField = {
        let object = SignUpTextField()
        object.placeholder = SignUpLocalized.recomentCodeTextField.rawValue
        return object
    }()
    
    let signUpButton: UIButton = {
        let object = UIButton(type: .system)
        object.setTitle(SignUpLocalized.SignUpTitle.rawValue, for: .normal)
        object.titleLabel?.font = .boldSystemFont(ofSize: 14)
        object.setTitleColor(.black, for: .normal)
        object.backgroundColor = .white
        object.layer.cornerRadius = 8
        return object
    }()
    
    let addInfoLabel: UILabel = {
        let object = UILabel()
        object.text = SignUpLocalized.addInfoText.rawValue
        object.font = .systemFont(ofSize: 14)
        object.textColor = .white
        return object
    }()
    
    let addInfoSwitch: UISwitch = {
        let object = UISwitch()
        //switch resize
        object.transform = CGAffineTransformMakeScale(0.8, 0.8)
        object.onTintColor = .red
        object.isOn = true
        return object
    }()
    
//MARK: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy(){
        view.addSubview(titleLabel)
        view.addSubview(textFieldStackView)
        
        [emailTextField, pwdTextField, nicknameTextField, addressTextField, recomentCodeTextField].map {
            textFieldStackView.addArrangedSubview($0)
        }
        
        view.addSubview(signUpButton)
        view.addSubview(addInfoLabel)
        view.addSubview(addInfoSwitch)
    }
    
    func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(-100)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        addInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(14)
            make.leading.equalTo(signUpButton.snp.leading)
        }
        
        addInfoSwitch.snp.makeConstraints { make in
            make.top.equalTo(addInfoLabel.snp.top)
            make.trailing.equalTo(textFieldStackView.snp.trailing)
        }
    }
    
}
