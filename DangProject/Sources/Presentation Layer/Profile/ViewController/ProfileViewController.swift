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
    
    private lazy var saveButton = SaveButton()
    
    private lazy var loadingAlertController = UIAlertController(title: nil,
                                                                message: "프로필 업데이트 중입니다..",
                                                                preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfileData()
    }
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupViewController()
        setupProfileNavigationBar()
        setupProfileImageButton()
        setupProfileStackView()
        setupSaveButton()
        setupLoadingAlertController()
        view.bringSubviewToFront(navigationBar)
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
    
    private func setupProfileImageButton() {
        view.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: yValueRatio(150)),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: xValueRatio(125)),
            profileImageButton.heightAnchor.constraint(equalToConstant: yValueRatio(125))
        ])
    }
    
    private func setupProfileStackView() {
        view.addSubview(profileStackView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: yValueRatio(70)),
            profileStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            profileStackView.heightAnchor.constraint(equalToConstant: yValueRatio(400))
        ])
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: yValueRatio(105)),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        saveButton.saveButton.rx.tap
            .bind { [weak self] in
                guard let nameData = self?.profileStackView.nameView.profileTextField.text,
                      let profileImage = self?.profileImageButton.profileImageView.image,
                      let heightData = self?.profileStackView.heightView.profileTextField.text,
                      let weightData = self?.profileStackView.weightView.profileTextField.text else { return }
                
                self?.viewModel.saveProfile(ProfileDomainModel(uid: "",
                                                               name: nameData,
                                                               height: Int(heightData) ?? 0,
                                                               weight: Int(weightData) ?? 0,
                                                               sugarLevel: self?.viewModel.profileDataRelay.value.sugarLevel ?? 0,
                                                               profileImage: profileImage)) { _ in
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
    
    @objc private func scrollViewDidTap(_ sender: UIScrollView) {
        self.view.endEditing(true)
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
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        self.profileImageButton.profileImageView.image = image
        profileImagePicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profileImagePicker.dismiss(animated: true)
    }
}

extension ProfileViewController: ProfileImageButtonProtocol {
    
    func profileImageButtonTapped() {
        present(profileImagePicker, animated: true)
    }
}

