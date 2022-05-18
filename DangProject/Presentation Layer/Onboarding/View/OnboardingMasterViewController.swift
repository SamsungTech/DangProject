//
//  ViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/08.
//

import UIKit

import RxSwift
import RxCocoa

class OnboardingMasterViewController: UIViewController {
    
    
    var coordinator: OnboardingCoordinator?
    let viewModel: OnboardingViewModel
    
    private var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal)
    private var pageControl = UIPageControl()
    private var nextButton = UIButton()
    private var startButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    init(viewModel: OnboardingViewModel) {
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
        setupViews()
        bindCurrentPageIndexObservable()
        
    }
    
    private func setupViews() {
        setupPageViewController()
        setupPageControl()
        setupNextButton()
        setupStartButton()
    }
    
    private func setupPageViewController() {
        view.addSubview(pageViewController.view)
        pageViewController.view.backgroundColor = .systemGray
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(750))
        ])
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([viewModel.viewControllers[0]], direction: .forward, animated: true)
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor,
                                             constant: self.view.yValueRatio(20)),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(30))
        ])
        pageControl.numberOfPages = viewModel.viewControllers.count
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    @objc private func pageChanged() {
        if viewModel.currentPage < pageControl.currentPage {
            pageViewController.setViewControllers([viewModel.viewControllers[pageControl.currentPage]], direction: .forward, animated: true)
        } else {
            pageViewController.setViewControllers([viewModel.viewControllers[pageControl.currentPage]], direction: .reverse, animated: true)
        }
        
        viewModel.changeIndex(to: pageControl.currentPage)
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor,
                                            constant: self.view.yValueRatio(15)),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: self.view.xValueRatio(-30)),
            nextButton.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(35)),
            nextButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(50))
        ])
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.tintColor = .black
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor,
                                             constant: self.view.yValueRatio(15)),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: self.view.xValueRatio(-30)),
            startButton.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(70)),
            startButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(40))
        ])
        startButton.setTitle("Start!", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        startButton.isHidden = true
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextIndex()
        pageViewController.setViewControllers([viewModel.viewControllers[viewModel.currentPage]], direction: .forward, animated: true)
    }
    
    @objc func startButtonTapped() {
        coordinator?.dissmiss()
    }
    
    func bindCurrentPageIndexObservable() {
        viewModel.currentPageIndexObservable
            .bind(onNext: { [weak self] pageIndex in
                guard let strongSelf = self else { return }
                self?.pageControl.currentPage = pageIndex
                if pageIndex == strongSelf.viewModel.viewControllers.count-1 {
                    self?.nextButton.isHidden = true
                    self?.startButton.isHidden = false
                } else {
                    self?.startButton.isHidden = true
                    self?.nextButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
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
            viewModel.changeIndex(to: index)
        }
    }
    
}
