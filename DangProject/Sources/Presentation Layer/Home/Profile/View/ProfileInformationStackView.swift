//
//  ProfileInformationStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/15.
//

import UIKit

class ProfileInformationStackView: UIStackView {
    private let profileDummyData = ProfileDummy()
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
    lazy var targetDangPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var nameView: NameTextField = {
        let view = NameTextField()
        view.profileLabel.text = "이름"
        view.profileTextField.insertText("김동우")
        view.frame = CGRect(x: .zero,
                                 y: .zero,
                                 width: calculateXMax(),
                                 height: yValueRatio(100))
        return view
    }()
    
    @available(iOS 13.4, *)
    lazy var birthDateView: DateTextFieldView = {
        let view = DateTextFieldView()
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
        view.profileTextField.inputView = heightPickerView
        return view
    }()
    
    lazy var weightView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "몸무게"
        view.profileTextField.insertText("76 kg")
        view.profileTextField.inputView = weightPickerView
        return view
    }()
    
    private(set) lazy var targetSugarView: DangTextFieldView = {
        let view = DangTextFieldView()
        view.profileLabel.text = "목표 당"
        view.profileTextField.insertText("20.0")
        view.profileTextField.inputView = targetDangPickerView
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.4, *) {
            configureUI()
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileInformationStackView {
    @available(iOS 13.4, *)
    private func configureUI() {
        setUpStackView()
    }
    
    @available(iOS 13.4, *)
    private func setUpStackView() {
        let views = [ nameView, birthDateView, genderView, heightView, weightView, targetSugarView ]
        
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 10
        views.forEach() { self.addArrangedSubview($0) }
    }
}
extension ProfileInformationStackView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weightPickerView {
            switch component {
            case 0:
                return 150
            case 1:
                return 10
            case 2:
                return 1
            default:
                return 0
            }
        } else if pickerView == heightPickerView {
            switch component {
            case 0:
                return 200
            case 1:
                return 10
            case 2:
                return 1
            default:
                return 0
            }
        } else {
            switch component {
            case 0:
                return 100
            case 1:
                return 10
            case 2:
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
                return String(row + 1)
            case 1:
                return String(row + 1)
            case 2:
                return "kg"
            default:
                return ""
            }
        } else if pickerView == heightPickerView {
            switch component {
            case 0:
                return String(row + 1)
            case 1:
                return String(row + 1)
            case 2:
                return "cm"
            default:
                return ""
            }
        } else {
            switch component {
            case 0:
                return String(row + 1)
            case 1:
                return String(row + 1)
            case 2:
                return "g"
            default:
                return ""
            }
        }
    }
}
