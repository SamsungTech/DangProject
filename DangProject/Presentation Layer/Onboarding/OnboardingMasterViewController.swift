//
//  ViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/08.
//

import UIKit

class OnboardingMasterViewController: UIViewController {
    
    var viewModel = OnboardingViewModel()
    
    var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal)
    var pageControl = UIPageControl()
    var nextButton = UIButton()
    var startButton = UIButton()
    var currentIndex = 0 {
        didSet {
            if currentIndex == viewModel.viewControllers.count - 1 {
                nextButton.isHidden = true
                startButton.isHidden = false
            } else {
                nextButton.isHidden = false
                startButton.isHidden = true
            }
        }
    }
    
    let navi = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPageViewController()
        setupPageControl()
        setupNextButton()
        setupStartButton()
        
        navi.view.backgroundColor = .white
        navi.title = "Login"
    }
    
    private func setupPageViewController() {
        view.addSubview(pageViewController.view)
        pageViewController.view.backgroundColor = .systemGray
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                            constant: -100)
        ])
        pageViewController.delegate = self
        pageViewController.dataSource = self
        viewModel.makeViewControllers()
        pageViewController.setViewControllers([viewModel.viewControllers[0]], direction: .forward, animated: true)
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor,
                                             constant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        pageControl.numberOfPages = viewModel.viewControllers.count
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    @objc func pageChanged() {
        if currentIndex < pageControl.currentPage {
            pageViewController.setViewControllers([viewModel.viewControllers[pageControl.currentPage]], direction: .forward, animated: true)
        } else {
            pageViewController.setViewControllers([viewModel.viewControllers[pageControl.currentPage]], direction: .reverse, animated: true)
        }
        currentIndex = pageControl.currentPage
    }
    
    func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 15),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalToConstant: 25),
            nextButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        let imageConfiguration = UIImage.SymbolConfiguration.init(hierarchicalColor: .black)
        nextButton.setImage(UIImage(systemName: "chevron.right", withConfiguration: imageConfiguration), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func setupStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.widthAnchor.constraint(equalToConstant: 60),
            startButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        startButton.setTitle("Start!", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        startButton.isHidden = true
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        guard currentIndex >= 0 && currentIndex < viewModel.viewControllers.count-1 else { return }
        
        currentIndex = currentIndex+1
        pageViewController.setViewControllers([viewModel.viewControllers[currentIndex]], direction: .forward, animated: true)
        pageControl.currentPage = currentIndex
        
    }
    
    @objc func startButtonTapped() {
        viewModel.closeOnboardingView()
        navigationController?.pushViewController(navi, animated: true)
        self.presentingViewController?.dismiss(animated: false)
    }
}

extension OnboardingMasterViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard var index = (viewController as! OnboardingContentViewController).pageIndex else { return nil }
        guard index > 0 else {return nil}
        index -= 1
        return viewModel.viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var index = (viewController as! OnboardingContentViewController).pageIndex else { return nil }
        index += 1
        guard index < viewModel.contentImages.count else {return nil}
        return viewModel.viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPageViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
            let index = viewModel.viewControllers.firstIndex(of: currentPageViewController)!
            currentIndex = index
            pageControl.currentPage = index
        }
    }
    
}
