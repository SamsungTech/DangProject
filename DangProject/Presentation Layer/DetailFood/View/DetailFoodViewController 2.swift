//
//  DetailFoodViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation
import UIKit
protocol DetailFoodParentable {
    func favoriteTapped(foodModel: FoodViewModel)
    func addFoodsAfter(food: AddFoodsViewModel)
}
class DetailFoodViewController: UIViewController {
    
    weak var coordinator: DetailFoodCoordinator?
    
    let viewModel: DetailFoodViewModel
    
    var parentableViewController: DetailFoodParentable?
    
    private let indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "indicator")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let image = UIImage(named: "hand.png")
    var favoriteButton = UIButton()
    let sugarAmountLabel = UILabel()
    let sugarLabel = UILabel()
    let amountTextField = UITextField()
    let amountPerButton = UIButton()
    let amountPickerView = UIPickerView()
    var pickerList: [String] = {
        var arr: [String] = []
        for i in 0...10 {
            arr.append("\(i)")
        }
        return arr
    }()
    let pickerToolbar = UIToolbar()
    let addButton = UIButton()
    var addButtonTopConstraint: NSLayoutConstraint?
    var amountPickerHeightConstraint: NSLayoutConstraint?
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
    }
    // MARK: - Set Views
    private func setUpViews() {
        setUpBackGround()
        setUpRightNavigationItem()
        setUpIndicatorImageView()
        setUpArrowImageView()
        setUpArrowInclination()
        setUpSugarAmountLabel()
        setUpSugarLabel()
        setUpAmountButton()
        setUpAmountPerButton()
        setUpAmountPickerView()
        setUpAddButton()
    }
    
    private func setUpBackGround() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = viewModel.detailFood.name
    }
    
    private func setUpRightNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.setImage(viewModel.detailFood.image, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc func favoriteButtonTapped() {
        parentableViewController?.favoriteTapped(foodModel: viewModel.detailFood)
        viewModel.changeDetailFoodFavorite()
        favoriteButton.setImage(viewModel.detailFood.image, for: .normal)
    }
    private func setUpIndicatorImageView() {
        view.addSubview(indicatorImageView)
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30).isActive = true
        indicatorImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        indicatorImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        indicatorImageView.heightAnchor.constraint(equalToConstant: view.frame.height*0.3).isActive = true
    }
    
    private func setUpArrowImageView() {
        view.addSubview(arrowImageView)
        arrowImageView.backgroundColor = .clear
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.centerXAnchor.constraint(equalTo: indicatorImageView.centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height*0.3*0.75).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: view.frame.width*0.85).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.85).isActive = true
    }
    
    private func setUpArrowInclination() {
        arrowImageView.image = image
        UIView.animate(withDuration: 2.0, animations: { [self] in
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: viewModel.setSugarArrowAngle(amount: 1)*CGFloat.pi / 180)
        })
    }
    
    private func setUpSugarAmountLabel() {
        view.addSubview(sugarAmountLabel)
        sugarAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarAmountLabel.topAnchor.constraint(equalTo: indicatorImageView.bottomAnchor, constant: 25).isActive = true
        sugarAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sugarAmountLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sugarAmountLabel.text = viewModel.detailFood.sugar == "" ? "0g" : "\(viewModel.detailFood.sugar!)g"
        sugarAmountLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        sugarAmountLabel.textColor = UIColor.black
    }
    
    private func setUpSugarLabel() {
        view.addSubview(sugarLabel)
        sugarLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarLabel.topAnchor.constraint(equalTo: sugarAmountLabel.bottomAnchor).isActive = true
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
        amountTextField.delegate = self
        amountTextField.keyboardType = .numberPad
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
        
        let imageConfiguration = UIImage.SymbolConfiguration.init(hierarchicalColor: .black)
        amountPerButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfiguration), for: .normal)
        
        amountPerButton.semanticContentAttribute = .forceRightToLeft
        amountPerButton.titleEdgeInsets = .init(top: 0, left: -40, bottom: 0, right: 0)
        amountPerButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -80)
        
        amountPerButton.addTarget(self, action: #selector(amountPerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func amountPerButtonTapped() {
        let imageConfiguration = UIImage.SymbolConfiguration.init(hierarchicalColor: .black)
        addButtonTopConstraint?.isActive = false
        amountPickerHeightConstraint?.isActive = false
        if amountPickerView.frame.height == 0 {
            amountPerButton.setImage(UIImage(systemName: "chevron.up", withConfiguration: imageConfiguration), for: .normal)
            addButtonTopConstraint =  addButton.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 220)
            amountPickerHeightConstraint = amountPickerView.heightAnchor.constraint(equalToConstant: 200)
        } else {
            amountPerButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfiguration), for: .normal)
            addButtonTopConstraint =  addButton.topAnchor.constraint(equalTo: amountPerButton.bottomAnchor, constant: 10)
            amountPickerHeightConstraint = amountPickerView.heightAnchor.constraint(equalToConstant: 0)
        }
        addButtonTopConstraint?.isActive = true
        amountPickerHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    
    @objc private func addButtonTapped(completion: @escaping()->Void) {
        guard let amount = Int(amountTextField.text!) else { return }
        viewModel.addFoods(foods: AddFoodsViewModel.init(amount: amount, foodModel: viewModel.detailFood))
        self.navigationController?.popViewController(animated: true)
        parentableViewController?.addFoodsAfter(food: AddFoodsViewModel.init(amount: amount, foodModel: viewModel.detailFood))
 
    }
    
    private func updateSugarLabelAndAnimation(amount: Double) {
        UIView.animate(withDuration: 2.0, animations: { [self] in
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: viewModel.setSugarArrowAngle(amount: amount)*CGFloat.pi / 180)
        })
        sugarAmountLabel.text = viewModel.detailFood.sugar == "" ? "0g" : "\((Double(viewModel.detailFood.sugar!)!*amount).roundDecimal(to: 2))g"
        // buttonSet
        if amount == 0 {
            addButton.backgroundColor = .systemGray4
            addButton.isEnabled = false
        } else {
            addButton.backgroundColor = .systemBlue
            addButton.isEnabled = true
        }
    }
    
}
// MARK: - Extension
extension DetailFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if amountPickerView.frame.height == 0 {
            return 0
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return pickerList.count
        case 1: return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return view.frame.width*0.3
        case 1: return view.frame.width*0.7
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return pickerList[row]
        case 1: return amountPerButton.currentTitle
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let amount = pickerList[row]
        amountTextField.text = amount
        
        if let foodAmount = Double(amountTextField.text!) {
            updateSugarLabelAndAnimation(amount: foodAmount)
            sugarAmountLabel.text = viewModel.detailFood.sugar == "" ? "0g" : "\((Double(viewModel.detailFood.sugar!)!*foodAmount).roundDecimal(to: 2))g"
        }
    }
}
extension DetailFoodViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if amountTextField.text == "" {
            amountTextField.text = "0"
        }
        guard let amount = Double(amountTextField.text!) else { return }
        updateSugarLabelAndAnimation(amount: amount)
        self.view.endEditing(true)
    }
}
