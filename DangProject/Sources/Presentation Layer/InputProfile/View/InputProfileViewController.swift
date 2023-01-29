import Foundation
import UIKit

import RxSwift
import RxCocoa

class InputProfileViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    weak var coordinator: InputProfileCoordinator?
    private let viewModel: InputProfileViewModel
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    private lazy var loadingView = LoadingView(frame: .zero)

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: yValueRatio(20), weight: .bold)
        label.text = "환영해요 🥳\n 마지막으로 개인정보를 입력해주세요!"
        return label
    }()
    
    private lazy var profileImageButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.delegate = self
        return button
    }()
    
    let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    private var stackViewBottomConstraint: NSLayoutConstraint?
    
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
    
    private lazy var emailTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "이메일"
        view.profileTextField.textColor = .gray
        view.profileTextField.isEnabled = false
        view.profileTextField.text = coordinator?.retrieveInputEmail()
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    private lazy var nameTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "이름"
        view.profileTextField.placeholder = "사용자의 이름"
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    private lazy var heightTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "키"
        view.profileTextField.placeholder = "사용자의 키"
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        view.profileTextField.inputView = heightPickerView
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    private lazy var weightTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "몸무게"
        view.profileTextField.tag = 0
        view.profileTextField.placeholder = "사용자의 몸무게"
        view.profileTextField.delegate = self
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        view.profileTextField.inputView = weightPickerView
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    private lazy var sugarTextFieldView: AnimationTextFieldView = {
        let view = AnimationTextFieldView()
        view.profileLabel.text = "목표 당 수치"
        view.profileTextField.tag = 1
        view.profileTextField.placeholder = "사용자의 목표한 당 수치"
        view.profileTextField.delegate = self
        sugarLevelPickerView.delegate = self
        sugarLevelPickerView.dataSource = self
        view.profileTextField.inputView = sugarLevelPickerView
        view.frame = .profileViewDefaultCGRect(55)
        return view
    }()
    
    private lazy var readyButton: SaveView = {
        let view = SaveView()
        view.setupSaveViewState(state: .untouchable)
        view.saveButton.addTarget(self, action: #selector(submitInformation), for: .touchUpInside)
        view.saveButton.setTitle("준비완료", for: .normal)
        return view
    }()
    
    // MARK: - Init
    init(viewModel: InputProfileViewModel) {
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
        configureImagePicker()
        setupBindings()
    }
    
    // MARK: - layoutViews
    private func layoutViews() {
        layoutStackView()
        layoutProfileImageButton()
        layoutWelcomeLabel()
        layoutReadyButton()
        setupLoadingView()
    }
    
    private func layoutStackView() {
        let views: [UIView] = [emailTextFieldView, nameTextFieldView, heightTextFieldView,
                               weightTextFieldView, sugarTextFieldView]
        views.forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -yValueRatio(105))
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: yValueRatio(450))
        ])
        stackViewBottomConstraint?.isActive = true
    }
    
    private func layoutProfileImageButton() {
        view.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -yValueRatio(20)),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: yValueRatio(125)),
            profileImageButton.heightAnchor.constraint(equalToConstant: yValueRatio(125))
        ])
    }
    
    private func layoutWelcomeLabel() {
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: -yValueRatio(20)),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            welcomeLabel.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(60)),
            welcomeLabel.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(320))
        ])
    }
    
    private func layoutReadyButton() {
        view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            readyButton.heightAnchor.constraint(equalToConstant: yValueRatio(105)),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Others
    
    private func configureImagePicker() {
        imagePicker.delegate = self
    }
    
    // MARK: - setupBindings
    private func setupBindings() {
        bindPickerView()
        bindProfileImageView()
        bindReadyButton()
        bindLoadingView()
    }
    
    private func bindPickerView() {
        viewModel.heightObservable
            .bind(onNext: { [weak self] height in
                self?.heightTextFieldView.profileTextField.text = "\(height)cm"
            })
            .disposed(by: disposeBag)
        
        viewModel.weightObservable
            .bind(onNext: { [weak self] weight in
                self?.weightTextFieldView.profileTextField.text = "\(weight)kg"
            })
            .disposed(by: disposeBag)
        
        viewModel.sugarObservable
            .bind(onNext: { [weak self] sugar in
                self?.sugarTextFieldView.profileTextField.text = "\(sugar)g"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileImageView() {
        viewModel.profileImageObservable
            .bind(onNext: { [unowned self] image in
                self.profileImageButton.profileImageView.image = image
                imagePicker.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindReadyButton() {
        viewModel.readyButtonIsValid
            .bind(onNext: { [unowned self] isReady in
                if isReady && !nameTextFieldView.profileTextField.text!.isEmpty {
                    readyButton.setupSaveViewState(state: .touchable)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingView() {
        viewModel.loading
            .bind { [weak self] state in
                switch state {
                case .startLoading:
                    self?.loadingView.showLoading()
                case .finishLoading:
                    self?.loadingView.hideLoading()
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func changeProfileButtonTapped() {
        self.present(imagePicker, animated: true)
    }
    
    @objc private func submitInformation() {
        viewModel.loading.accept(.startLoading)
        if let name = nameTextFieldView.profileTextField.text {
            viewModel.submitButtonTapped(name: name) { [weak self] data in
                if data {
                    self?.viewModel.loading.accept(.finishLoading)
                    self?.coordinatorFinishDelegate?.switchViewController(to: .tabBar)
                } else {
                    guard let alert = self?.createAlert() else { return }
                    self?.viewModel.loading.accept(.finishLoading)
                    self?.present(alert, animated: false)
                }
            }
        }
    }
    
    // MARK: - Create Method
    
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
}

extension InputProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            animateStackViewBottomSpace(180)
        case 1:
            animateStackViewBottomSpace(280)
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateStackViewBottomSpace(105)
    }
    
    private func animateStackViewBottomSpace(_ constant: CGFloat) {
        stackViewBottomConstraint?.constant = -yValueRatio(constant)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension InputProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension InputProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        viewModel.changeProfileImage(image: newImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}

extension InputProfileViewController: ProfileImageButtonProtocol {
    func profileImageButtonTapped() {
        self.present(imagePicker, animated: true)
    }
}
