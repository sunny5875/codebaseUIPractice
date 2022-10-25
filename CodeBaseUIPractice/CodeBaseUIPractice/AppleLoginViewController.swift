//
//  AppleLoginViewController.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/24.
//

import UIKit
import SnapKit
import SwiftUI
import AuthenticationServices

class AppleLoginViewController: UIViewController {

    // 원하는 객채를 이름붙여 만들어줌
//    private lazy var
    private lazy var nameLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "👩🏻‍💻Sunny's Login👩🏻‍💻"
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.layer.cornerRadius = 5
        return label
    }()
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var textFieldStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 5
        button.setTitle("회원가입", for: .normal)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 5
        button.setTitle("Apple 회원가입", for: .normal)
        button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc func appleLoginButtonTapped(_: UITapGestureRecognizer) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email] // 얻을 수 있는 값 : 이름과 이메일

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as? ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }

    func addSubViews() {
        [nameLbl, textFieldStackView, loginButton, signUpButton, appleLoginButton]
            .forEach { self.view.addSubview($0) }
    }
    
    func setLayout() {
        // 아래부터 띄워놓은 객체들에게 각각의 위치를 부여해줌
        self.nameLbl.snp.makeConstraints {
          // self.nameLbl은 superView로부터 center에 위치함
            $0.top.equalToSuperview().offset(128)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        /*
        self.emailTextField.snp.makeConstraints {
          // self.nameTextField의 top은 superView로 부터 80 떨어짐
          // leading, trailing은 각각 24만큼 떨어짐
          $0.top.equalToSuperview().offset(80)
          $0.leading.equalToSuperview().offset(16)
          $0.trailing.equalToSuperview().offset(-16)
      }
        self.passwordTextField.snp.makeConstraints {
          // self.nameTextField의 top은 superView로 부터 80 떨어짐
          // leading, trailing은 각각 24만큼 떨어짐
          $0.top.equalTo(self.emailTextField.snp.bottom).offset(8)
          $0.leading.equalToSuperview().offset(16)
          $0.trailing.equalToSuperview().offset(-16)
      }
     */
        self.textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(self.nameLbl.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        self.loginButton.snp.makeConstraints {
            $0.top.equalTo(self.textFieldStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(self.nameLbl)
            $0.width.equalTo(100)
        }
        
        self.appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(self.loginButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.nameLbl)
            $0.width.equalTo(100)
        }
        
        self.signUpButton.snp.makeConstraints {
            $0.top.equalTo(self.appleLoginButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.nameLbl)
            $0.width.equalTo(100)
        }
        
       
        
    }
    // 이름만 만들어준 객체를 실제로 뷰에 띄움
    override func viewDidLoad() {
      super.viewDidLoad()
    
      addSubViews()
      setLayout()
     
    }
    

}

extension AppleLoginViewController: ASAuthorizationControllerDelegate {
    // 성공 후 동작
       func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
           
           if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {

               let idToken = credential.identityToken!
               let tokeStr = String(data: idToken, encoding: .utf8)
               print(tokeStr as Any)

               guard let code = credential.authorizationCode else { return }
               let codeStr = String(data: code, encoding: .utf8)
               print(codeStr as Any)

               // user의 정보 : 최초 로그인에서만 이름과 이메일을 받을 수 있고 그 후에는 ID값만 리턴
               let user = credential.user
               let fullName = credential.fullName
               let email = credential.email
               
               print(user)
               print(fullName as Any)
               print(email as Any)
               
               let repo = KeyChainRepository()
               repo.addValueOnKeyChain(value: user, key: USER_IDENTIFIER_STRING)

           }
       }

       // 실패 후 동작
       func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
           print("error")
       }
}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = AppleLoginViewController

    func makeUIViewController(context: Context) -> AppleLoginViewController {
        return AppleLoginViewController()
    }

    func updateUIViewController(_ uiViewController: AppleLoginViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}