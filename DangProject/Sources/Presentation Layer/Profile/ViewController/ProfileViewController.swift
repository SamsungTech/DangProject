//
//  ProfileViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift

class ProfileViewController: CustomViewController {
    weak var coordinator: ProfileCoordinator?
    private var viewModel: ProfileViewModelProtocol
    private let disposeBag = DisposeBag()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "프로필"
        return navigationBar
    }()
    
    private lazy var profileImageButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.delegate = self
        return button
    }()
    
    private lazy var profileStackView: ProfileInformationStackView = {
        let stackView = ProfileInformationStackView(frame: .zero, viewModel: viewModel)
        return stackView
    }()
    
    private lazy var profileImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    private lazy var saveView: SaveView = {
        let view = SaveView()
        view.saveButton.setTitle("저장", for: .normal)
        return view
    }()
    
    private var stackViewTopConstraint: NSLayoutConstraint?
    
    private lazy var loadingAlertController = UIAlertController(title: nil,
                                                                message: "프로필 업데이트 중입니다..",
                                                                preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegate()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfileData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearImageData()
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
    
    private func setupTextFieldDelegate() {
        profileStackView.nameView.profileTextField.delegate = self
        profileStackView.heightView.profileTextField.delegate = self
        profileStackView.weightView.profileTextField.delegate = self
    }
    
    private func clearImageData() {
        self.profileImageButton.profileImageView.image = nil
    }
    
    private func configureUI() {
        setupViewController()
        setupProfileStackView()
        setupProfileImageButton()
        setupSaveButton()
        setupLoadingAlertController()
        setupProfileNavigationBar()
    }
    
    private func setupViewController() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBoxColor
    }
    
    private func setupProfileNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: -yValueRatio(5)),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -xValueRatio(5)),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: xValueRatio(5)),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(100))
        ])
    }
    
    private func setupProfileStackView() {
        view.addSubview(profileStackView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewTopConstraint = profileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: yValueRatio(345))
        NSLayoutConstraint.activate([
            profileStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            profileStackView.heightAnchor.constraint(equalToConstant: yValueRatio(350))
        ])
        stackViewTopConstraint?.isActive = true
    }
    
    private func setupProfileImageButton() {
        view.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageButton.bottomAnchor.constraint(equalTo: profileStackView.topAnchor, constant: -yValueRatio(70)),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: yValueRatio(125)),
            profileImageButton.heightAnchor.constraint(equalToConstant: yValueRatio(125))
        ])
    }
    
    private func setupSaveButton() {
        view.addSubview(saveView)
        saveView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            saveView.heightAnchor.constraint(equalToConstant: yValueRatio(105)),
            saveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingAlertController() {
        let loadingIndicator = UIActivityIndicatorView()
        loadingAlertController.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingAlertController.view.centerYAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: loadingAlertController.view.leadingAnchor,
                                                      constant: xValueRatio(18))
        ])
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
    }
    
    private func bind() {
        bindUI()
        bindSaveButton()
        bindProfileData()
        bindAnimationValue()
        bindLoadingState()
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popViewController()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSaveButton() {
        saveView.saveButton.rx.tap
            .bind { [weak self] in
                guard let nameData = self?.profileStackView.nameView.profileTextField.text,
                      let profileImage = self?.profileImageButton.profileImageView.image,
                      let heightData = self?.profileStackView.heightView.profileTextField.text,
                      let weightData = self?.profileStackView.weightView.profileTextField.text,
                      let email = self?.profileStackView.emailTextFieldView.profileTextField.text else { return }
                
                self?.viewModel.saveProfile(ProfileDomainModel(uid: "",
                                                               email: email,
                                                               name: nameData,
                                                               height: Int(heightData) ?? 0,
                                                               weight: Int(weightData) ?? 0,
                                                               sugarLevel: self?.viewModel.profileDataRelay.value.sugarLevel ?? 0,
                                                               profileImage: profileImage)) { isDone in
                    if isDone == false {
                        guard let alert = self?.createAlert() else { return }
                        self?.present(alert, animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindProfileData() {
        viewModel.profileDataRelay
            .subscribe(onNext: { [weak self] in
                guard let heightIndex = self?.viewModel.getHeightSelectRowIndex($0.height),
                      let weightIndex = self?.viewModel.getWeightSelectRowIndex($0.weight) else { return }
                self?.profileStackView.nameView.profileTextField.text = $0.name
                self?.profileStackView.emailTextFieldView.profileTextField.text = $0.email
                self?.profileStackView.heightView.profileTextField.text = String($0.height)
                self?.profileStackView.heightPickerView.selectRow(heightIndex, inComponent: 0, animated: false)
                self?.profileStackView.weightView.profileTextField.text = String($0.weight)
                self?.profileStackView.weightPickerView.selectRow(weightIndex, inComponent: 0, animated: false)
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
                    self.navigationBar.layer.borderColor = UIColor.clear.cgColor
                case .scrolling:
                    self.navigationBar.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingState() {
        viewModel.loadingRelay
            .subscribe(onNext: { [weak self] loading in
                guard let strongSelf = self else { return }
                switch loading {
                case .startLoading:
                    self?.present(strongSelf.loadingAlertController, animated: true, completion: nil)
                case .finishLoading:
                    self?.dismiss(animated: true)
                    self?.coordinator?.popViewController()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류",
                                      message: "Firebase ProfileUpdate - 실패",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionButton = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(actionButton)
        return alert
    }
    
    @objc private func scrollViewDidTap(_ sender: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            animateStackViewBottomSpace(325)
            profileStackView.nameView.setupNameTextFieldState(isEditing: true)
        case 1:
            animateStackViewBottomSpace(310)
            profileStackView.heightView.setupNameTextFieldState(isEditing: true)
        case 2:
            animateStackViewBottomSpace(220)
            profileStackView.weightView.setupNameTextFieldState(isEditing: true)
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            animateStackViewBottomSpace(345)
            profileStackView.nameView.setupNameTextFieldState(isEditing: false)
        case 1:
            animateStackViewBottomSpace(345)
            profileStackView.heightView.setupNameTextFieldState(isEditing: false)
        case 2:
            animateStackViewBottomSpace(345)
            profileStackView.weightView.setupNameTextFieldState(isEditing: false)
        default: break
        }
    }
    
    private func animateStackViewBottomSpace(_ constant: CGFloat) {
        stackViewTopConstraint?.constant = yValueRatio(constant)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.calculateScrollViewState(yPosition: scrollView.contentOffset.y)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        setupProfileImage(image)
        profileImagePicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profileImagePicker.dismiss(animated: true)
    }
    
    private func setupProfileImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageButton.profileImageView.image = image
        }
    }
}

extension ProfileViewController: ProfileImageButtonProtocol {
    func profileImageButtonTapped() {
        present(profileImagePicker, animated: true)
    }
}

