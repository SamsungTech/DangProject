//
//  ProfileInformationStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/15.
//

import UIKit

class ProfileInformationStackView: UIStackView {
    lazy var nameView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "이름"
        view.profileTextField.insertText("김동우")
        view.frame = CGRect(x: .zero,
                                 y: .zero,
                                 width: calculateXMax(),
                                 height: yValueRatio(100))
        return view
    }()
    
    lazy var birthDateView: CustomDateTextFieldView = {
        let view = CustomDateTextFieldView()
        view.profileLabel.text = "생년월일"
        view.profileTextField.insertText("1996년 6월 9일")
        view.frame = CGRect(x: .zero,
                                 y: .zero,
                                 width: calculateXMax(),
                                 height: yValueRatio(100))
        return view
    }()
    
    lazy var genderView: GenderView = {
        let view = GenderView()
        view.frame = CGRect(x: .zero,
                            y: .zero,
                            width: calculateXMax(),
                            height: yValueRatio(100))
        return view
    }()
    
    lazy var heightView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "키"
        view.profileTextField.insertText("184 cm")
        return view
    }()
    
    lazy var weightView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "몸무게"
        view.profileTextField.insertText("76 kg")
        return view
    }()
    
    lazy var targetSugarView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "목표 당"
        view.profileTextField.insertText("20.0")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileInformationStackView {
    private func configureUI() {
        setUpStackView()
    }
    
    private func setUpStackView() {
        let views = [ nameView, birthDateView, genderView, heightView, weightView, targetSugarView ]
        
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 10
        views.forEach() { self.addArrangedSubview($0) }
    }
}
