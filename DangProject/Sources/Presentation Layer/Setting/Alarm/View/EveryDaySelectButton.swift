//
//  File.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/02.
//

import UIKit

class EveryDaySelectButton: UIButton {
    private(set) lazy var circleView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.viewRadius(cornerRadius: xValueRatio(10))
        return view
    }()
    
    private(set) lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(13), weight: .semibold)
        label.text = "매일"
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCircleViewCheckMark() {
        circleView.layer.borderWidth = 0
        circleView.image = UIImage.init(systemName: "checkmark.circle.fill")
        circleView.tintColor = .circleColorGreen
    }
    
    func setCircleViewNormal() {
        circleView.image = nil
        circleView.layer.borderWidth = 2
    }
}

extension EveryDaySelectButton {
    private func configureUI() {
        setUpCircleView()
        setUpDaysLabel()
    }
    
    private func setUpCircleView() {
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: xValueRatio(20)),
            circleView.heightAnchor.constraint(equalToConstant: yValueRatio(20))
        ])
    }
    
    private func setUpDaysLabel() {
        addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            daysLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: xValueRatio(10)),
            daysLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
