//
//  TabBarController.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    var coordinator: Coordinator?
    let homeTab: UINavigationController
    let settingTab: UINavigationController
    let searchViewController: UINavigationController
    private lazy var homeItemButton: TabBarItem = {
        let button = TabBarItem()
        button.tag = 0
        button.tintColor = .black
        button.itemImageView.image = UIImage(systemName: "house.fill")
        button.itemTitleLabel.text = "홈"
        button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingItemButton: TabBarItem = {
        let button = TabBarItem()
        button.tintColor = .black
        button.tag = 2
        button.itemImageView.image = UIImage(systemName: "gearshape")
        button.itemTitleLabel.text = "설정"
        button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        return button
    }()
    
     lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .homeBoxColor
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "dangLogoBlackColor"), for: .normal)
        button.viewRadius(cornerRadius: yValueRatio(40))
        button.layer.borderWidth = yValueRatio(6)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    init(homeTab: UINavigationController,
         settingTab: UINavigationController,
         searchViewController: UINavigationController) {
        self.homeTab = homeTab
        self.settingTab = settingTab
        self.searchViewController = searchViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarBackgroundView()
        setupHomeItemButton()
        setupSettingItemButton()
        setupAddButton()
    }
    
    private func setupTabBar() {
        self.viewControllers = [homeTab, UIViewController(), settingTab]
        self.tabBar.isHidden = true
    }
    
    private func setupTabBarBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(90)),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -xValueRatio(5)),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: yValueRatio(5))
        ])
        backgroundView.roundCorners(cornerRadius: yValueRatio(30), maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    }
    
    private func setupHomeItemButton() {
        backgroundView.addSubview(homeItemButton)
        homeItemButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeItemButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -xValueRatio(20)),
            homeItemButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: xValueRatio(UIScreen.main.bounds.maxX/6)),
            homeItemButton.widthAnchor.constraint(equalToConstant: yValueRatio(35)),
            homeItemButton.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        ])
    }
    
    private func setupSettingItemButton() {
        backgroundView.addSubview(settingItemButton)
        settingItemButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingItemButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -xValueRatio(20)),
            settingItemButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -xValueRatio(UIScreen.main.bounds.maxX/6)),
            settingItemButton.widthAnchor.constraint(equalToConstant: yValueRatio(35)),
            settingItemButton.heightAnchor.constraint(equalToConstant: yValueRatio(52.5))
        ])
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: yValueRatio(80)),
            addButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -yValueRatio(25)),
            addButton.widthAnchor.constraint(equalToConstant: yValueRatio(80)),
            addButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
    
    private func itemDidSelected(_ tag: Int) {
        if tag == 0 {
            homeItemButton.itemImageView.image = UIImage(systemName: "house.fill")
            settingItemButton.itemImageView.image = UIImage(systemName: "gearshape")
        } else if tag == 2 {
            homeItemButton.itemImageView.image = UIImage(systemName: "house")
            settingItemButton.itemImageView.image = UIImage(systemName: "gearshape.fill")
        }
    }
    
    @objc func itemTapped(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        itemDidSelected(sender.tag)
    }
    
    @objc func addButtonTapped() {
        guard let currentViewController = viewControllers?[selectedIndex] else {
            return
        }
        (coordinator as? TabBarCoordinator)?.presentSearchViewController(viewController: currentViewController)
    }
    
    func hideTabBar() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.2) { [weak self] in
            self?.backgroundView.alpha = 0
            self?.addButton.alpha = 0
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.backgroundView.isHidden = true
            self?.addButton.isHidden = true
        }

    }
    
    func showTabBar() {
        UIView.animate(withDuration: 0.2, delay: 0.2) { [weak self] in
            self?.backgroundView.alpha = 1
            self?.addButton.alpha = 1
            self?.backgroundView.isHidden = false
            self?.addButton.isHidden = false
            self?.view.layoutIfNeeded()
        }
    }
}
