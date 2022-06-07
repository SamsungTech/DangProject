//
//  ToolBarButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/20.
//

import UIKit

class ToolBarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolBarButton {
    private func configureUI() {
        setUpView()
    }
    
    private func setUpView() {
        self.backgroundColor = .circleColorGreen
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.frame = CGRect(x: .zero,
                            y: .zero,
                            width: calculateXMax(),
                            height: yValueRatio(50))
    }
}
