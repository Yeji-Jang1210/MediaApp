//
//  SignUpTextField.swift
//  MediaApp
//
//  Created by 장예지 on 6/5/24.
//

import UIKit
import SnapKit

class SignUpTextField: UITextField {
    
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.backgroundColor = .darkGray
        self.textColor = .white
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 12)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
