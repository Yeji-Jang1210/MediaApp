//
//  ExpandTextViewCell.swift
//  MediaApp
//
//  Created by 장예지 on 6/11/24.
//

import UIKit
import SnapKit

class ExpandTextViewCell: UITableViewCell {
    
    static var identifier = String(describing: ExpandTextViewCell.self)

    //MARK: - object
    
    let backView: UIView = {
        let object = UIView()
        object.backgroundColor = .clear
        return object
    }()
    
    let textView: UITextView = {
        let object = UITextView()
        object.backgroundColor = .clear
        object.font = .systemFont(ofSize: 14)
        object.textColor = .white
        object.isScrollEnabled = false
        object.isEditable = false
        return object
    }()
    
    let button: UIButton = {
        let object = UIButton(type: .system)
        object.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        object.tintColor = UIColor.systemGray2
        return object
    }()
    
    //MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - configure function
    func configureHierarchy(){
        contentView.addSubview(backView)
        
        backView.addSubview(textView)
        backView.addSubview(button)
    }
    
    func configureLayout(){
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(textView.snp.horizontalEdges)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configureUI(){
        
    }
    
    //MARK: - function
    public func fetchData(_ text: String?){
        textView.text = text
    }
}
