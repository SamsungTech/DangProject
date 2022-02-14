//
//  LoadingView.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/08.
//

import Foundation
import UIKit

public class LoadingView {
    // 사용 시 매번 객체생성이 필요 없으므로 static으로 사용할 수 있게끔 선언
    let customFrame: CGRect
    
    init(customFrame: CGRect) {
        self.customFrame = customFrame
    }
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.safeAreaLayoutGuide.layoutFrame
                // 이 frame을 건드려야되는데..
                loadingIndicatorView.color = .darkGray
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
    
}

