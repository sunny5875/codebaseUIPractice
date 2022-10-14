//
//  ViewController.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/13.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private lazy var homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private lazy var box: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    private func setLayout() {
        addViews()
        box.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        button.isEqual(view.center)
    }
    func addViews() {
        view.addSubview(homeLabel)
        view.addSubview(box)
        view.addSubview(button)
    }
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        let secondVC = SecondViewController(myString: "수빈")
        self.navigationController?.pushViewController(secondVC, animated: true)
    }

}
