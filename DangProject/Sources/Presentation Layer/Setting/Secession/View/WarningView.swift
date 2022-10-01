//
//  WarningView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/20.
//

import UIKit

class WarningView: UIView {
    private lazy var warningTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customLabelColorBlack
        label.font = UIFont.systemFont(ofSize: xValueRatio(17), weight: .semibold)
        label.text = "경고"
        return label
    }()
    
    private lazy var warningContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customFontColorGray
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .regular)
        label.numberOfLines = 3
        label.text = "계정을 탈퇴하시면 귀하의 모든 체중, 식사 및 검색 \n데이터들이 모두 제거 됩니다. 귀하의 프로필에도 \n더이상 접근할 수 없게 됩니다."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WarningView {
    private func configureUI() {
        setUpWarningTitleLabel()
        setUpWarningContentLabel()
    }
    
    private func setUpWarningTitleLabel() {
        addSubview(warningTitleLabel)
        warningTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warningTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            warningTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setUpWarningContentLabel() {
        addSubview(warningContentLabel)
        warningContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warningContentLabel.topAnchor.constraint(equalTo: warningTitleLabel.bottomAnchor, constant: yValueRatio(20)),
            warningContentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
