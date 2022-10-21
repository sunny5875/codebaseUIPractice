//
//  SwiftUIPreview.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/21.
//

import UIKit
import RxSwift

class CustomCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "globe")
        view.contentMode = .scaleAspectFit
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//       gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
//       gradient.locations = [0.0, 1.0]
//       gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//       gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//       gradient.frame = bounds
//        view.layer.addSublayer(gradient)
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 20 // view.intrinsicContentSize.width / 2.0
        return view
    }()
    

    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "ETH 크립토1"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .systemBackground
        
        [logoImageView, nameLabel]
            .forEach { contentView.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(4)
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
        
       
    }
    
    func setData(data: String) {
        nameLabel.text = data
    }
    

}
