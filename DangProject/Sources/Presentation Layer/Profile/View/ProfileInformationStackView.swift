//
//  ProfileInformationStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/15.
//

import UIKit

class ProfileInformationStackView: UIStackView {
    var viewModel: ProfileViewModelProtocol
    private var views: [UIView] = []
    lazy var weightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    lazy var heightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var emailTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "이메일"
        view.profileTextField.textColor = .gray
        view.profileTextField.isEnabled = false
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    lazy var nameView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "이름"
        view.profileTextField.tag = 0
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    lazy var heightView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "키"
        view.profileTextField.tintColor = .clear
        view.profileTextField.tag = 1
        view.profileTextField.inputView = heightPickerView
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    lazy var weightView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "몸무게"
        view.profileTextField.tintColor = .clear
        view.profileTextField.tag = 2
        view.profileTextField.inputView = weightPickerView
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    init(frame: CGRect,
         viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
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
        views = [ emailTextFieldView, nameView, heightView, weightView ]
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = yValueRatio(10)
        views.forEach() { self.addArrangedSubview($0) }
    }
}

extension ProfileInformationStackView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weightPickerView {
            switch component {
            case 0:
                return viewModel.weights.count
            case 1:
                return 1
            default:
                return 0
            }
        } else {
            switch component {
            case 0:
                return viewModel.heights.count
            case 1:
                return 1
            default:
                return 0
            }
        }
    }
}

extension ProfileInformationStackView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == weightPickerView {
            switch component {
            case 0:
                return viewModel.weights[row]
            case 1:
                return "kg"
            default:
                return ""
            }
        } else {
            switch component {
            case 0:
                return viewModel.heights[row]
            case 1:
                return "cm"
            default:
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
        case weightPickerView:
            weightView.profileTextField.text = viewModel.weights[row]
        case heightPickerView:
            heightView.profileTextField.text = viewModel.heights[row]
        default:
            break
        }
    }
}
