import Foundation
import UIKit

import RxSwift
import RxCocoa

class InputPersonalInformationViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    weak var coordinator: InputPersonalInformationCoordinator?
    private let viewModel: InputPersonalInformationViewModel
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "환영해요 🥳\n 마지막으로 개인정보를 입력해주세요!"
        return label
    }()
    
    private lazy var changeProfileButton: UIButton = {
        let button = UIButton()
        let changeProfileButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .light, scale: .large)
        let profileImage = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: changeProfileButtonConfiguration)
        button.setImage(profileImage, for: .normal)
        button.tintColor = .purple
        button.addTarget(self, action: #selector(changeProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var heightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 0
        return pickerView
    }()
    private lazy var weightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 1
        return pickerView
    }()
    private lazy var sugarLevelPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 2
        return pickerView
    }()
    private lazy var nameTextField = self.createTextField()
    private lazy var heightTextField = self.createTextField()
    private lazy var weightTextField = self.createTextField()
    private lazy var sugarTextField = self.createTextField()
    
    private lazy var nameInputSection = self.createInputSection(text: "이름",
                                                                withTextField: nameTextField,
                                                                withPickerView: nil)
    private lazy var heightInputSection = self.createInputSection(text: "키",
                                                                  withTextField: heightTextField,
                                                                  withPickerView: heightPickerView)
    private lazy var weightInputSection = self.createInputSection(text: "몸무게",
                                                                  withTextField: weightTextField,
                                                                  withPickerView: weightPickerView)
    private lazy var sugarInputSection = self.createInputSection(text: "목표 당 수치",
                                                                 withTextField: sugarTextField,
                                                                 withPickerView: sugarLevelPickerView)
    
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemBlue
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        heightTextField.inputAccessoryView = toolbar
        weightTextField.inputAccessoryView = toolbar
        sugarTextField.inputAccessoryView = toolbar
        return toolbar
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitInformation), for: .touchUpInside)
        button.roundCorners(cornerRadius: self.view.frame.width*0.6/12)
        button.setTitle("준비완료!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    // MARK: - Init
    init(viewModel: InputPersonalInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutViews()
        configureToolbars()
        configureImagePicker()
        setupBindings()
    }
    
    // MARK: - layoutViews
    private func layoutViews() {
        layoutWelcomeLabel()
        layoutChangeProfileButton()
        layoutNameInputSection()
        layoutHeightInputSection()
        layoutWeightInputSection()
        layoutSugarLevelInputSection()
        layoutReadyButton()
    }
    
    private func layoutWelcomeLabel() {
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor,
                                              constant: self.view.yValueRatio(60)),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            welcomeLabel.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(60)),
            welcomeLabel.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(320))
        ])
    }
    
    private func layoutChangeProfileButton() {
        view.addSubview(changeProfileButton)
        changeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeProfileButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,
                                                     constant: self.view.yValueRatio(10)),
            changeProfileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            changeProfileButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(140)),
            changeProfileButton.widthAnchor.constraint(equalToConstant: self.view.yValueRatio(140))
        ])
    }
    
    private func layoutNameInputSection() {
        view.addSubview(nameInputSection)
        nameInputSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameInputSection.topAnchor.constraint(equalTo:changeProfileButton.bottomAnchor),
            nameInputSection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameInputSection.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(90)),
            nameInputSection.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(280))
        ])
    }
    
    private func layoutHeightInputSection() {
        view.addSubview(heightInputSection)
        heightInputSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightInputSection.topAnchor.constraint(equalTo: nameInputSection.bottomAnchor),
            heightInputSection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            heightInputSection.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(90)),
            heightInputSection.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(280))
        ])
    }
    
    private func layoutWeightInputSection() {
        view.addSubview(weightInputSection)
        weightInputSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightInputSection.topAnchor.constraint(equalTo: heightInputSection.bottomAnchor),
            weightInputSection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            weightInputSection.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(90)),
            weightInputSection.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(280))
        ])
    }
    
    private func layoutSugarLevelInputSection() {
        view.addSubview(sugarInputSection)
        sugarInputSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sugarInputSection.topAnchor.constraint(equalTo: weightInputSection.bottomAnchor),
            sugarInputSection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            sugarInputSection.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(90)),
            sugarInputSection.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(280))
        ])
    }
    
    private func layoutReadyButton() {
        view.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.topAnchor.constraint(equalTo: sugarInputSection.bottomAnchor,
                                             constant: self.view.yValueRatio(30)),
            readyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            readyButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(70)),
            readyButton.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(240))
        ])
        
    }
    // MARK: - Others
    
    private func configureToolbars() {
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: true)
    }
    
    @objc private func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
    }
    
    // MARK: - setupBindings
    private func setupBindings() {
        bindPickerView()
        bindProfileImageView()
        bindReadyButton()
    }
    
    private func bindPickerView() {
        
        viewModel.heightObservable
            .bind(onNext: { [weak self] height in
                self?.heightTextField.text = "\(height)cm"
            })
            .disposed(by: disposeBag)
        
        viewModel.weightObservable
            .bind(onNext: { [weak self] weight in
                self?.weightTextField.text = "\(weight)kg"
            })
            .disposed(by: disposeBag)
        
        viewModel.sugarObservable
            .bind(onNext: { [weak self] sugar in
                self?.sugarTextField.text = "\(sugar)g"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileImageView() {
        viewModel.profileImageObservable
            .bind(onNext: { [unowned self] image in
                changeProfileButton.roundCorners(cornerRadius: changeProfileButton.frame.width/2)
                self.changeProfileButton.setImage(image, for: .normal)
                imagePicker.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindReadyButton() {
        viewModel.readyButtonIsValid
            .bind(onNext: { [unowned self] isReady in
                if isReady && !nameTextField.text!.isEmpty {
                    readyButton.backgroundColor = .purple
                    readyButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    @objc private func changeProfileButtonTapped() {
        self.present(imagePicker, animated: true)
    }
    
    @objc private func submitInformation() {
        if let name = nameTextField.text {
            viewModel.submitButtonTapped(name: name)
        }
        coordinatorFinishDelegate?.switchViewController(to: .tabBar)
    }
    
    // MARK: - Create Method
    private func createToolBar(with textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.tag = textField.tag
        toolbar.tintColor = .systemBlue
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        textField.inputAccessoryView = toolbar
        return toolbar
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.tintColor = .purple
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.addPadding(left: 5)
        return textField
    }
    
    private func createInputSection(text: String,
                                    withTextField textField: UITextField,
                                    withPickerView pickerView: UIPickerView?) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = text
        
        if let pickerView = pickerView {
            textField.inputView = pickerView
            pickerView.delegate = self
            pickerView.dataSource = self
        }
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        return stackView
    }
}

extension InputPersonalInformationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return viewModel.numberOfComponents[pickerView.tag]
        case 1:
            return viewModel.numberOfComponents[pickerView.tag]
        case 2:
            return viewModel.numberOfComponents[pickerView.tag]
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return viewModel.numberOfRowsInComponents[pickerView.tag][component]
            case 1:
                return viewModel.numberOfRowsInComponents[pickerView.tag][component]
            default:
                return 0
            }
        case 1:
            switch component {
            case 0:
                return viewModel.numberOfRowsInComponents[pickerView.tag][component]
            case 1:
                return viewModel.numberOfRowsInComponents[pickerView.tag][component]
            default:
                return 0
            }
        case 2:
            return viewModel.numberOfRowsInComponents[pickerView.tag][component]
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            case 1:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            default:
                return ""
            }
            
        case 1:
            switch component {
            case 0:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            case 1:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            default:
                return ""
            }
        case 2:
            switch component {
            case 0:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            case 1:
                return viewModel.pickerViewValues[pickerView.tag][component][row]
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickerValueChanged(textFieldTag: pickerView.tag, row: row)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
extension InputPersonalInformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        viewModel.changeProfileImage(image: newImage)
    }
}
