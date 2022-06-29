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

protocol ProfileViewControllerProtocol: AnyObject {
    
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var coordinator: ProfileCoordinator?
    var viewModel: ProfileViewModelProtocol?
    private let disposeBag = DisposeBag()
    private var profileNavigationBar = ProfileNavigationBar()
    private var saveButtonBottomConstraint: NSLayoutConstraint?
    private var invisibleViewBottomConstraint: NSLayoutConstraint?
    private var selectedTextField: UITextField?
    
    private lazy var invisibleView: InvisibleView = {
        let view = InvisibleView()
        view.delegate = self
        return view
    }()
    
    private lazy var profileImageButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.delegate = self
        return button
    }()
    
    private lazy var profileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        viewModel?.viewDidLoad()
        configureUI()
        bind()
        view.bringSubviewToFront(profileNavigationBar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    init(viewModel: ProfileViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
        setUpInvisibleView()
    }
    
    private func bind() {
        if #available(iOS 13.4, *) {
            bindUI()
        } else {
            // Fallback on earlier versions
        }
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
            profileStackView.heightAnchor.constraint(equalToConstant: yValueRatio(700))
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
    
    private func setUpInvisibleView() {
        view.addSubview(invisibleView)
        view.bringSubviewToFront(invisibleView)
        invisibleView.translatesAutoresizingMaskIntoConstraints = false
        invisibleViewBottomConstraint = invisibleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: calculateYMax())
        invisibleViewBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            invisibleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invisibleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invisibleView.heightAnchor.constraint(equalToConstant: calculateYMax())
        ])
    }
    
    @available(iOS 13.4, *)
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
            .bind(to: viewModel!.genderRelay)
            .disposed(by: disposeBag)

        if #available(iOS 13.4, *) {
            Observable.merge(
                profileStackView.nameView.toolBarButton.rx.tap.map { TextFieldType.name },
                profileStackView.birthDatePickerView.toolBarButton.rx.tap.map { TextFieldType.birthDate },
                profileStackView.weightView.toolBarButton.rx.tap.map { TextFieldType.weight },
                profileStackView.heightView.toolBarButton.rx.tap.map { TextFieldType.height },
                profileStackView.targetSugarView.toolBarButton.rx.tap.map { TextFieldType.targetSugar }
            )
            .bind(to: viewModel!.okButtonRelay)
            .disposed(by: disposeBag)
        } else {
            Observable.merge(
                profileStackView.nameView.toolBarButton.rx.tap.map { TextFieldType.name },
                profileStackView.birthDateTextFieldView.toolBarButton.rx.tap.map { TextFieldType.birthDate },
                profileStackView.weightView.toolBarButton.rx.tap.map { TextFieldType.weight },
                profileStackView.heightView.toolBarButton.rx.tap.map { TextFieldType.height },
                profileStackView.targetSugarView.toolBarButton.rx.tap.map { TextFieldType.targetSugar }
            )
            .bind(to: viewModel!.okButtonRelay)
            .disposed(by: disposeBag)
        }

        saveButton.saveButton.rx.tap
            .bind { [weak self] in
                print("저-장")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAnimationValue() {
        viewModel?.scrollValue
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
        
        viewModel?.genderRelay
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
        
        viewModel?.saveButtonAnimationRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .up:
                    self.animateSaveButtonUp()
                    self.animateInvisibleViewDown()
                case .down:
                    self.animateSaveButtonDown()
                    self.animateInvisibleViewUp()
                case .none: break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.okButtonRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .none: break
                case .name:
                    self.viewModel?.saveButtonAnimationRelay.accept(.up)
                    self.profileStackView.nameView.profileTextField.resignFirstResponder()
                case .birthDate:
                    self.viewModel?.saveButtonAnimationRelay.accept(.up)
                    if #available(iOS 13.4, *) {
                        self.profileStackView.birthDatePickerView.profileTextField.resignFirstResponder()
                    } else {
                        self.profileStackView.birthDateTextFieldView.profileTextField.resignFirstResponder()
                    }
                case .height:
                    self.viewModel?.saveButtonAnimationRelay.accept(.up)
                    self.profileStackView.heightView.profileTextField.resignFirstResponder()
                case .weight:
                    self.viewModel?.saveButtonAnimationRelay.accept(.up)
                    self.profileStackView.weightView.profileTextField.resignFirstResponder()
                case .targetSugar:
                    self.viewModel?.saveButtonAnimationRelay.accept(.up)
                    self.profileStackView.targetSugarView.profileTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backgroundViewDidTap() {
        self.animateSaveButtonDown()
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.calculateScrollViewState(
            yPosition: scrollView.contentOffset.y
        )
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
    
    private func animateInvisibleViewDown() {
        invisibleViewBottomConstraint?.constant = calculateYMax()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateInvisibleViewUp() {
        invisibleViewBottomConstraint?.constant = 0
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
        viewModel?.saveButtonAnimationRelay.accept(.down)
        selectedTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.saveButtonAnimationRelay.accept(.up)
    }
}
