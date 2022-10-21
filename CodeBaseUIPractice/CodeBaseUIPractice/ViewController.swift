//
//  ViewController.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/13.
//

import UIKit
import SnapKit
import RxSwift
import SwiftUI
import RxCocoa

class ViewController: UIViewController {
    private let myArray = Observable.of( ["First", "Second", "Third"])
    private var disposeBag = DisposeBag()
    

//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 16
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.delegate = self
//        view.dataSource = self
//        view.showsVerticalScrollIndicator = false
//        view.alwaysBounceVertical = true
//        view.register(HomeNFTCell.self, forCellWithReuseIdentifier: HomeNFTCell.identifier)
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
//        view.refreshControl = refresh
//        view.backgroundColor = .white
//        return view
//    }()

//    private lazy var homeLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Home"
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 20)
//        label.textColor = .black
//        return label
//    }()
//    private lazy var box: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.layer.cornerRadius = 5
//        return view
//    }()
//
//    private lazy var button: UIButton = {
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 10
//        button.setTitle("Test Button", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        return button
//    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        view.backgroundColor = .systemBackground
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "RxSwift + CodeBase Practice"
        setLayout()
        bind()
    }
    
    private func bind() {
        myArray.bind(to: tableView.rx.items) { (tableView, _, element) in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell else {return UITableViewCell()}
            cell.setData(data: element)
            
            return cell
            
        }.disposed(by: disposeBag)
     
        
//        tableView.rx.modelSelected(String.self).subscribe(onNext: { model in
//
//        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                print("😄\(indexPath) selected")

                let secondVC = SecondViewController(myString: "수빈")
                self?.navigationController?.pushViewController(secondVC, animated: true)
            })
            .disposed(by: disposeBag)
   
        
    }
    private func setLayout() {
        addViews()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        
    }
    func addViews() {
        view.addSubview(tableView)
    }

    @objc private func pullToRefresh() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}



struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
