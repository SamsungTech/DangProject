//
//  ProfileViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

class ProfileViewController: UIViewController {
    var coordinator: ProfileCoordinator?
    private var viewModel: ProfileViewModelProtocol
    private let disposeBag = DisposeBag()
    private var profileNavigationBar = ProfileNavigationBar()
    private var saveButtonBottomConstraint: NSLayoutConstraint?
    private var selectedTextField: UITextField?
    private lazy var dateFormatter: DateFormatter = DateFormatter.formatDate()
    
    private lazy var profileImageButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.delegate = self
        return button
    }()
    
    private lazy var profileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewDidTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                        height: overSizeYValueRatio(1200))
        return scrollView
    }()
    
    private lazy var profileStackView: ProfileInformationStackView = {
        let stackView = ProfileInformationStackView()
        if #available(iOS 13.4, *) {
            stackView.birthDatePickerView.profileTextField.delegate = self
            stackView.birthDatePickerView.pickerView.addTarget(
                self,
                action: #selector(datePickerValueChanged(_:)),
                for: UIControl.Event.valueChanged
            )
        } else {
            stackView.birthDateTextFieldView.profileTextField.delegate = self
        }
        stackView.weightView.profileTextField.delegate = self
        stackView.heightView.profileTextField.delegate = self
        stackView.nameView.profileTextField.delegate = self
        return stackView
    }()
    
    private lazy var profileImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    private lazy var saveButton: SaveButton = {
        let view = SaveButton()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        view.bringSubviewToFront(profileNavigationBar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setUpViewController()
        setUpProfileNavigationBar()
        setUpScrollView()
        setUpProfileImageButton()
        setUpProfileStackView()
        setUpSaveButton()
    }
    
    private func bind() {
        bindUI()
        bindProfileData()
        bindAnimationValue()
    }
    
    private func setUpViewController() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
    }
    
    private func setUpProfileNavigationBar() {
        view.addSubview(profileNavigationBar)
        profileNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: -yValueRatio(5)),
            profileNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -xValueRatio(5)),
            profileNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: xValueRatio(5)),
            profileNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(100))
        ])
    }
    
    private func setUpScrollView() {
        view.addSubview(profileScrollView)
        profileScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            profileScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpProfileImageButton() {
        profileScrollView.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: profileScrollView.topAnchor, constant: yValueRatio(150)),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: xValueRatio(125)),
            profileImageButton.heightAnchor.constraint(equalToConstant: yValueRatio(125))
        ])
    }
    
    private func setUpProfileStackView() {
        profileScrollView.addSubview(profileStackView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: yValueRatio(70)),
            profileStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            profileStackView.heightAnchor.constraint(equalToConstant: yValueRatio(600))
        ])
    }
    
    private func setUpSaveButton() {
        profileScrollView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        saveButtonBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: yValueRatio(105)),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindUI() {
        profileNavigationBar.dismissButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                self?.coordinator?.dismissViewController(strongSelf)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            profileStackView.genderView.maleButton.rx.tap.map { GenderType.male },
            profileStackView.genderView.femaleButton.rx.tap.map { GenderType.female }
        )
        .bind(to: viewModel.genderRelay)
        .disposed(by: disposeBag)
        
        if #available(iOS 13.4, *) {
            newVersionBindUI()
        } else {
            lowerVersionBindUI()
        }
    }
    
    
    @available(iOS 13.4, *)
    private func newVersionBindUI() {
        Observable.merge(
            profileStackView.nameView.toolBarButton.rx.tap.map { TextFieldType.name },
            profileStackView.birthDatePickerView.toolBarButton.rx.tap.map { TextFieldType.birthDate },
            profileStackView.weightView.toolBarButton.rx.tap.map { TextFieldType.weight },
            profileStackView.heightView.toolBarButton.rx.tap.map { TextFieldType.height }
        )
        .bind(to: viewModel.okButtonRelay)
        .disposed(by: disposeBag)
        
        saveButton.saveButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self,
                      let nameData = self?.profileStackView.nameView.profileTextField.text,
                      let profileImage = self?.profileImageButton.profileImageView.image,
                      let heightData = self?.profileStackView.heightView.profileTextField.text,
                      let weightData = self?.profileStackView.weightView.profileTextField.text,
                      let birthData = self?.profileStackView.birthDatePickerView.profileTextField.text else { return }
                self?.viewModel.passProfileImageData(profileImage)
                
                self?.viewModel.passProfileData(
                    ProfileDomainModel(uid: "",
                                       name: nameData,
                                       height: Int(heightData) ?? 0,
                                       weight: Int(weightData) ?? 0,
                                       sugarLevel: self?.viewModel.profileDataRelay.value.sugarLevel ?? 0,
                                       profileImage: profileImage,
                                       gender: self?.viewModel.convertGenderTypeToString() ?? "",
                                       birthDay: birthData)
                )
                self?.coordinator?.dismissViewController(strongSelf)
            }
            .disposed(by: disposeBag)
    }
    
    private func lowerVersionBindUI() {
        Observable.merge(
            profileStackView.nameView.toolBarButton.rx.tap.map { TextFieldType.name },
            profileStackView.birthDateTextFieldView.toolBarButton.rx.tap.map { TextFieldType.birthDate },
            profileStackView.weightView.toolBarButton.rx.tap.map { TextFieldType.weight },
            profileStackView.heightView.toolBarButton.rx.tap.map { TextFieldType.height }
        )
        .bind(to: viewModel.okButtonRelay)
        .disposed(by: disposeBag)
        
        saveButton.saveButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self,
                      let nameData = self?.profileStackView.nameView.profileTextField.text,
                      let profileImage = self?.profileImageButton.profileImageView.image,
                      let heightData = self?.profileStackView.heightView.profileTextField.text,
                      let weightData = self?.profileStackView.weightView.profileTextField.text,
                      let birthData = self?.profileStackView.birthDateTextFieldView.profileTextField.text else { return }
                self?.viewModel.passProfileImageData(profileImage)
                self?.viewModel.passProfileData(
                    ProfileDomainModel(uid: "",
                                       name: nameData,
                                       height: Int(heightData) ?? 0,
                                       weight: Int(weightData) ?? 0,
                                       sugarLevel: self?.viewModel.profileDataRelay.value.sugarLevel ?? 0,
                                       profileImage: profileImage,
                                       gender: self?.viewModel.convertGenderTypeToString() ?? "",
                                       birthDay: birthData)
                )
                self?.coordinator?.dismissViewController(strongSelf)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindProfileData() {
        viewModel.profileDataRelay
            .subscribe(onNext: { [weak self] in
                self?.profileStackView.nameView.profileTextField.text = $0.name
                self?.profileStackView.heightView.profileTextField.text = String($0.height)
                self?.profileStackView.heightPickerView.selectRow($0.height-1, inComponent: 0, animated: false)
                self?.profileStackView.weightView.profileTextField.text = String($0.weight)
                self?.profileStackView.weightPickerView.selectRow($0.weight-1, inComponent: 0, animated: false)
                if #available(iOS 13.4, *) {
                    guard let date = self?.dateFormatter.date(from: $0.birthDay) else { return }
                    self?.profileStackView.birthDatePickerView.profileTextField.text = $0.birthDay
                    self?.profileStackView.birthDatePickerView.pickerView.date = date
                } else {
                    self?.profileStackView.birthDateTextFieldView.profileTextField.text = $0.birthDay
                }
                self?.profileImageButton.profileImageView.image = $0.profileImage
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAnimationValue() {
        viewModel.scrollValue
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .top:
                    self.profileNavigationBar.layer.borderColor = UIColor.clear.cgColor
                case .scrolling:
                    self.profileNavigationBar.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.genderRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .none:
                    break
                case .male:
                    self.animateMaleView()
                case .female:
                    self.animateFemaleView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.saveButtonAnimationRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .up:
                    self.animateSaveButtonUp()
                case .down:
                    self.animateSaveButtonDown()
                case .none: break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.okButtonRelay
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                self?.viewModel.saveButtonAnimationRelay.accept(.up)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backgroundViewDidTap() {
        self.animateSaveButtonDown()
    }
    
    @objc private func scrollViewDidTap(_ sender: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @available(iOS 13.4, *)
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let birthText = dateFormatter.string(from: profileStackView.birthDatePickerView.pickerView.date)
        profileStackView.birthDatePickerView.profileTextField.text = birthText
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.calculateScrollViewState(
            yPosition: scrollView.contentOffset.y
        )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        self.profileImageButton.profileImageView.image = image
        coordinator?.dismissPickerController()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        coordinator?.dismissPickerController()
    }
}

extension ProfileViewController {
    private func animateMaleView() {
        profileStackView.genderView.leadingConstraint?.constant = xValueRatio(5)
        profileStackView.genderView.maleButton.setTitleColor(.init(white: 1, alpha: 1), for: .normal)
        profileStackView.genderView.femaleButton.setTitleColor(.init(white: 1, alpha: 0.5), for: .normal)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateFemaleView() {
        profileStackView.genderView.leadingConstraint?.constant = xValueRatio(180)
        profileStackView.genderView.femaleButton.setTitleColor(.init(white: 1, alpha: 1), for: .normal)
        profileStackView.genderView.maleButton.setTitleColor(.init(white: 1, alpha: 0.5), for: .normal)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateSaveButtonDown() {
        saveButtonBottomConstraint?.constant = yValueRatio(105)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateSaveButtonUp() {
        saveButtonBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}

extension ProfileViewController: ProfileImageButtonProtocol, InvisibleViewProtocol {
    func profileImageButtonTapped() {
        coordinator?.presentPickerController(self)
    }
    
    func viewTapped() {
        if #available(iOS 13.4, *) {
            bringDownKeyboardWhileBirthPickerView()
        } else {
            bringDownKeyboardWhileBirthTextFieldView()
        }
    }
    
    @available(iOS 13.4, *)
    private func bringDownKeyboardWhileBirthPickerView() {
        if selectedTextField == profileStackView.birthDatePickerView.profileTextField {
            selectedTextField?.resignFirstResponder()
        } else {
            selectedTextField?.resignFirstResponder()
        }
    }
    
    private func bringDownKeyboardWhileBirthTextFieldView() {
        if selectedTextField == profileStackView.birthDateTextFieldView.profileTextField {
            selectedTextField?.resignFirstResponder()
        } else {
            selectedTextField?.resignFirstResponder()
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.saveButtonAnimationRelay.accept(.down)
        selectedTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.saveButtonAnimationRelay.accept(.up)
    }
}
