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
//import RxGesture

protocol ProfileViewControllerProtocol: AnyObject {
    
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var coordinator: ProfileCoordinator?
    var viewModel: ProfileViewModelProtocol?
    private let disposeBag = DisposeBag()
    private var profileImageButton = ProfileImageButton()
    private var profileNavigationBar = ProfileNavigationBar()
    private lazy var invisibleView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private var invisibleViewTopConstraint: NSLayoutConstraint?
    private var saveButtonBottomConstraint: NSLayoutConstraint?
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
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
        viewModel?.viewDidLoad()
        configureUI()
        if #available(iOS 13.4, *) {
            bind()
        } else {
            // Fallback on earlier versions
        }
        view.bringSubviewToFront(profileNavigationBar)
        view.bringSubviewToFront(invisibleView)
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
        setUpProfileNavigationBar()
        setUpScrollView()
        setUpProfileImageButton()
        setUpProfileStackView()
        setUpSaveButton()
        setUpInvisibleView()
    }
    
    @available(iOS 13.4, *)
    private func bind() {
        bindUI()
        bindAnimationValue()
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
        invisibleView.translatesAutoresizingMaskIntoConstraints = false
        invisibleViewTopConstraint = invisibleView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.maxY)
        invisibleViewTopConstraint?.isActive = true
        NSLayoutConstraint.activate([
            invisibleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invisibleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invisibleView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxY)
        ])
    }
    
    private func bindUI() {
//        profileImageButton.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.present(self.profileImagePicker, animated: true)
//            })
//            .disposed(by: disposeBag)
//
        profileNavigationBar.dismissButton.rx.tap
            .bind { [weak self] in
//                if let coordinator = self?.coordinator as? ProfileCoordinator {
//                    coordinator.dismissViewController()
//                }
            }
            .disposed(by: disposeBag)
//
//        invisibleView.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.viewModel?.saveButtonDidTap()
//                self.profileStackView.nameView.profileTextField.resignFirstResponder()
//                self.profileStackView.birthDateView.profileTextField.resignFirstResponder()
//                self.profileStackView.heightView.profileTextField.resignFirstResponder()
//                self.profileStackView.weightView.profileTextField.resignFirstResponder()
//                self.profileStackView.targetSugarView.profileTextField.resignFirstResponder()
//            })
//            .disposed(by: disposeBag)
//
//        Observable.merge(
//            profileStackView.nameView.profileTextField.rx.tapGesture().map { _ in },
//            profileStackView.birthDateView.profileTextField.rx.tapGesture().map { _ in  },
//            profileStackView.heightView.profileTextField.rx.tapGesture().map { _ in },
//            profileStackView.weightView.profileTextField.rx.tapGesture().map { _ in },
//            profileStackView.targetSugarView.profileTextField.rx.tapGesture().map { _ in  }
//        )
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.viewModel?.saveButtonDidTap()
//            })
//            .disposed(by: disposeBag)
//
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
                    self.viewModel?.saveButtonDidTap()
                    self.profileStackView.nameView.profileTextField.resignFirstResponder()
                case .birthDate:
                    self.viewModel?.saveButtonDidTap()
                    if #available(iOS 13.4, *) {
                        self.profileStackView.birthDatePickerView.profileTextField.resignFirstResponder()
                    } else {
                        self.profileStackView.birthDateTextFieldView.profileTextField.resignFirstResponder()
                    }
                case .height:
                    self.viewModel?.saveButtonDidTap()
                    self.profileStackView.heightView.profileTextField.resignFirstResponder()
                case .weight:
                    self.viewModel?.saveButtonDidTap()
                    self.profileStackView.weightView.profileTextField.resignFirstResponder()
                case .targetSugar:
                    self.viewModel?.saveButtonDidTap()
                    self.profileStackView.targetSugarView.profileTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backgroundViewDidTap() {
        print("탭됨 ㅇㅋ?")
        
        self.viewModel?.saveButtonDidTap()
        self.profileStackView.nameView.profileTextField.resignFirstResponder()
        if #available(iOS 13.4, *) {
            self.profileStackView.birthDatePickerView.profileTextField.resignFirstResponder()
        } else {
            self.profileStackView.birthDateTextFieldView.profileTextField.resignFirstResponder()
        }
        self.profileStackView.heightView.profileTextField.resignFirstResponder()
        self.profileStackView.weightView.profileTextField.resignFirstResponder()
        self.profileStackView.targetSugarView.profileTextField.resignFirstResponder()
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
        
        // Coordinator로 옮기기
        profileImagePicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profileImagePicker.dismiss(animated: true)
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
        invisibleViewTopConstraint?.constant = UIScreen.main.bounds.maxY
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateInvisibleViewUp() {
        invisibleViewTopConstraint?.constant = 0
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}
