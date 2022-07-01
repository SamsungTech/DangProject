//
//  ProfileInformationStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/15.
//

import UIKit

protocol InputViewDelegate: AnyObject {
    func didTapView()
}

class ProfileInformationStackView: UIStackView {
    private let profileDummyData = ProfileDummy()
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
    lazy var targetDangPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    @available(iOS 13.4, *)
    lazy var birthDatePickerView: DateTextFieldView = {
        let view = DateTextFieldView()
        view.profileLabel.text = "생년월일"
        view.frame = CGRect(x: .zero,
                            y: .zero,
                            width: calculateXMax(),
                            height: yValueRatio(100))
        return view
    }()
    
    lazy var nameView: NameTextField = {
        let view = NameTextField()
        view.profileLabel.text = "이름"
        view.frame = CGRect(x: .zero,
                                 y: .zero,
                                 width: calculateXMax(),
                                 height: yValueRatio(100))
        return view
    }()
    
    lazy var birthDateTextFieldView: DangTextFieldView = {
        let view = DangTextFieldView()
        view.profileLabel.text = "생년월일"
        view.profileTextField.placeholder = "예) 19960609"
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
        view.profileTextField.inputView = heightPickerView
        return view
    }()
    
    lazy var weightView: ProfileTextFieldView = {
        let view = ProfileTextFieldView()
        view.profileLabel.text = "몸무게"
        view.profileTextField.inputView = weightPickerView
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
        if #available(iOS 13.4, *) {
            views = [ nameView, birthDatePickerView, genderView, heightView, weightView ]
        } else {
            views = [ nameView, birthDateTextFieldView, genderView, heightView, weightView ]
        }
        
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
