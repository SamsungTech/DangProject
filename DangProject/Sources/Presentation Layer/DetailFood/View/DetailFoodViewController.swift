//
//  DetailFoodViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation
import UIKit

import RxSwift

protocol DetailFoodParentable {
    func favoriteTapped(foodModel: FoodViewModel)
    func addFoodsAfter(food: AddFoodsViewModel)
}
class DetailFoodViewController: UIViewController {
    weak var coordinator: DetailFoodCoordinator?
    let viewModel: DetailFoodViewModel
    var parentableViewController: DetailFoodParentable?
    
    private var favoriteButton = UIButton()
    private let totalSugarLabel = UILabel()
    private let sugarLabel = UILabel()
    private let amountTextField = UITextField()
    private let amountPerButton = UIButton()
    private let amountPickerView = UIPickerView()
    
    private let pickerToolbar = UIToolbar()
    private let addButton = UIButton()
    private var addButtonTopConstraint: NSLayoutConstraint?
    private var amountPickerHeightConstraint: NSLayoutConstraint?
    
    private var customProgressBar = CustomProgressBar()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: DetailFoodViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupBindings()
    }
    
    // MARK: - Set Views
    private func setUpViews() {
        setUpBackGround()
        setUpRightNavigationItem()
        setUpCustomProgressBar()
        setUpSugarAmountLabel()
        setUpSugarLabel()
        setUpAmountButton()
        setUpAmountPerButton()
        setUpAmountPickerView()
        setUpAddButton()
    }
    
    private func setUpBackGround() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black,
                                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: yValueRatio(20), weight: .bold)]
        self.navigationItem.title = viewModel.detailFood.name
    }
    
    private func setUpRightNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.setImage(viewModel.detailFood.image, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        parentableViewController?.favoriteTapped(foodModel: viewModel.detailFood)
        viewModel.changeDetailFoodFavorite()
        favoriteButton.setImage(viewModel.detailFood.image, for: .normal)
    }
    
    private func setUpCustomProgressBar() {
        view.addSubview(customProgressBar)
        customProgressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customProgressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            customProgressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: xValueRatio(10)),
            customProgressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -xValueRatio(10)),
            customProgressBar.heightAnchor.constraint(equalToConstant: yValueRatio(220))
        ])
    }
    
    private func setUpSugarAmountLabel() {
        view.addSubview(totalSugarLabel)
        totalSugarLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSugarLabel.topAnchor.constraint(equalTo: customProgressBar.bottomAnchor, constant: 25).isActive = true
        totalSugarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalSugarLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        totalSugarLabel.text = viewModel.detailFood.sugar == "" ? "0g" : "\(viewModel.detailFood.sugar!)g"
        totalSugarLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        totalSugarLabel.textColor = UIColor.black
    }
    
    private func setUpSugarLabel() {
        view.addSubview(sugarLabel)
        sugarLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarLabel.topAnchor.constraint(equalTo: totalSugarLabel.bottomAnchor).isActive = true
        sugarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sugarLabel.text = "당분"
        sugarLabel.font = UIFont.systemFont(ofSize: 15)
        sugarLabel.textColor = UIColor.black
    }
    
    private func setUpAmountButton() {
        view.addSubview(amountTextField)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.topAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 20).isActive = true
        amountTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.25).isActive = true
        amountTextField.bottomAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 50).isActive = true
        amountTextField.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        amountTextField.backgroundColor = .systemGray4
        amountTextField.text = "1"
        amountTextField.textColor = UIColor.black
        amountTextField.textAlignment = .right
        amountTextField.addPadding(left: 0, right: 15)
        amountTextField.keyboardType = .numberPad
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let amount = amountTextField.text else { return }
        viewModel.amountChanged(amount: Int(amount) ?? 0)
    }
    
    private func setUpAmountPerButton() {
        view.addSubview(amountPerButton)
        amountPerButton.translatesAutoresizingMaskIntoConstraints = false
        amountPerButton.topAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 20).isActive = true
        amountPerButton.leadingAnchor.constraint(equalTo: amountTextField.trailingAnchor, constant: 3).isActive = true
        amountPerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        amountPerButton.bottomAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 50).isActive = true
        amountPerButton.roundCorners(cornerRadius: 15, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        amountPerButton.backgroundColor = .systemGray4
        
        amountPerButton.setTitle("1인분 (1회 제공량 당)", for: .normal)
        amountPerButton.setTitleColor(.black, for: .normal)
        
        amountPerButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        amountPerButton.tintColor = .black
        
        amountPerButton.semanticContentAttribute = .forceRightToLeft
        amountPerButton.titleEdgeInsets = .init(top: 0, left: -40, bottom: 0, right: 0)
        amountPerButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -60)
        
        amountPerButton.addTarget(self, action: #selector(amountPerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func amountPerButtonTapped() {
        viewModel.changePickerViewWillActivated()
    }
    
    private func setUpAmountPickerView() {
        view.addSubview(amountPickerView)
        amountPickerView.translatesAutoresizingMaskIntoConstraints = false
        amountPickerView.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 5).isActive = true
        amountPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        amountPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        amountPickerHeightConstraint = amountPickerView.heightAnchor.constraint(equalToConstant: 0)
        amountPickerHeightConstraint?.isActive = true
        amountPickerView.delegate = self
        amountPickerView.dataSource = self
        amountPickerView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        amountPickerView.backgroundColor = .systemGray4
    }
    
    private func setUpAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButtonTopConstraint = addButton.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 10)
        addButtonTopConstraint?.isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.roundCorners(cornerRadius: 30, maskedCorners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        addButton.setTitle("추가", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        addButton.backgroundColor = .systemBlue
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        guard let amount = Int(amountTextField.text ?? "1") else { return }
        
        viewModel.addFoods(foods: .init(amount: amount, foodModel: viewModel.detailFood)) { [weak self] data in
            if data {
                guard let detailFood = self?.viewModel.detailFood else { return }
                self?.parentableViewController?.addFoodsAfter(
                    food: AddFoodsViewModel.init(amount: amount,
                                                 foodModel: detailFood)
                )
                self?.coordinator?.popViewController()
            } else {
                guard let alert = self?.createAlert() else { return }
                self?.present(alert, animated: false)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        bindPickerView()
        bindDetailFood()
    }
    
    private func bindPickerView() {
        viewModel.pickerViewIsActivatedObservable
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] pickerIsActivated in
                guard let strongSelf = self,
                      let isFirst = self?.viewModel.branchOutPickerViewInActivated() else { return }
                if isFirst {
                    strongSelf.setupAmountPickerViewAnimation(pickerIsActivated: pickerIsActivated)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupAmountPickerViewAnimation(pickerIsActivated: Bool) {
        addButtonTopConstraint?.isActive = false
        amountPickerHeightConstraint?.isActive = false
        if pickerIsActivated {
            increasePickerView()
        } else {
            decreasePickerView()
        }
    }
    
    private func increasePickerView() {
        amountPerButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        amountPerButton.tintColor = .black
        addButtonTopConstraint =  addButton.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 220)
        amountPickerHeightConstraint = amountPickerView.heightAnchor.constraint(equalToConstant: 200)
        addButtonTopConstraint?.isActive = true
        amountPickerHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func decreasePickerView() {
        amountPerButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        amountPerButton.tintColor = .black
        addButtonTopConstraint =  addButton.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 10)
        amountPickerHeightConstraint = amountPickerView.heightAnchor.constraint(equalToConstant: 0)
        addButtonTopConstraint?.isActive = true
        amountPickerHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func bindDetailFood() {
        viewModel.detailFoodObservable
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] food in
                guard let totalSugar = self?.viewModel.getTotalSugar(),
                      let amount = self?.viewModel.amount,
                      let state = self?.viewModel.branchOutCircleState(amount: Double(amount)),
                      let angle = self?.viewModel.setSugarArrowAngle(amount: Double(amount)) else { return }
                
                self?.totalSugarLabel.text = "\(totalSugar.roundDecimal(to: 2))g"
                self?.amountTextField.text = "\(amount)"
                self?.customProgressBar.animateProgressBar(angle: angle,
                                                           state: state)
                
                if self?.viewModel.amount == 0 {
                    self?.changeAddButtonDeactivated()
                } else {
                    self?.changeAddButtonActivated()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func changeAddButtonActivated() {
        addButton.backgroundColor = .systemBlue
        addButton.isEnabled = true
    }
    
    private func changeAddButtonDeactivated() {
        addButton.backgroundColor = .systemGray4
        addButton.isEnabled = false
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류",
                                      message: "firebaseServer 연결 오류",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionButton = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(actionButton)
        return alert
    }
}
// MARK: - Extension
extension DetailFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return viewModel.pickerList.count
        case 1: return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return view.frame.width*0.2
        case 1: return view.frame.width*0.8
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return viewModel.pickerList[row]
        case 1: return amountPerButton.currentTitle
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let amount = viewModel.pickerList[row]
        
        viewModel.amountChanged(amount: Int(amount) ?? 0)
    }
}
