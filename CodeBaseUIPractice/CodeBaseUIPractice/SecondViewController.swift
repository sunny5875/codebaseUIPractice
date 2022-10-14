//
//  SecondViewController.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/13.
//

import Foundation
import UIKit
import SnapKit

class SecondViewController: UIViewController {

    var text = ""
    
    convenience init( myString: String ) {
       self.init()
       self.text = myString
   }
    
    
    let homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Second"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        label.backgroundColor = .red
        return label
    }()
    lazy var box = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mainLabelConstraints()
        print(self.text)
    }
    func setup() {
        view.backgroundColor = .white
        addViews()
    }
    func addViews() {
        view.addSubview(homeLabel)
        view.addSubview(box)

    }
    func mainLabelConstraints() {
        homeLabel.translatesAutoresizingMaskIntoConstraints = false // 오토리사이징x -> 코드로 작성하기 위해서 자동으로
        homeLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        homeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true // 높이
        homeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        box.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }

}
