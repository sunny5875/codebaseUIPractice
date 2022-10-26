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

import FirebaseAuth
import CryptoKit

import FirebaseCore
import GoogleSignIn

class AppleLoginViewController: UIViewController {
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    private var repo = KeyChainRepository()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage() // UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var logoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SUNNY PLAYGROUND"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 이메일을 입력하세요"
//        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 비밀번호를 입력하세요"
//        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.isSecureTextEntry = true
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
        button.layer.cornerRadius = 30
        button.setTitle("로그인", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    
        return button
    }()
    
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.cornerRadius = 30
        let image = UIImage(named: "appleid_button.png")
        button.setBackgroundImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ] // .double.rawValue, .thick.rawValue
        let attributeString = NSMutableAttributedString(
               string: "회원가입",
               attributes: yourAttributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var firebaseGoogleLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "google.png"), for: .normal)
        button.clipsToBounds = true
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.borderColor = UIColor.systemGray6.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(firebaseGoogleSignInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var firebaseAppleLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "apple.png"), for: .normal)
        button.clipsToBounds = true
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = button.bounds.size.height / 2
        
        button.addTarget(self, action: #selector(firebaseAppleSignInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var firebaseFaceBookLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "apple.png"), for: .normal)
        button.clipsToBounds = true
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = button.bounds.size.height / 2
        
        button.addTarget(self, action: #selector(firebaseAppleSignInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var firebaseLoginStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [firebaseGoogleLoginButton, firebaseAppleLoginButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()

    lazy var spinnerView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true // stop하면 안보이도록 할 것
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating() // default는 stop으로 설정
        
        return activityIndicator
    }()
    
    // 이름만 만들어준 객체를 실제로 뷰에 띄움
    override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationItem.hidesBackButton = true
      addSubViews()
      setLayout()
     
    }
    
    func addSubViews() {
        [logoNameLabel, textFieldStackView, loginButton, signUpButton, appleLoginButton, firebaseLoginStackView, spinnerView] // z스택처럼 쌓임
            .forEach { self.view.addSubview($0) }
    }
    
    func setLayout() {
        // 아래부터 띄워놓은 객체들에게 각각의 위치를 부여해줌
        self.logoNameLabel.snp.makeConstraints {
          // self.nameLbl은 superView로부터 center에 위치함
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        self.emailTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        self.passwordTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }

        self.textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(self.logoNameLabel.snp.bottom).offset(64)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        self.loginButton.snp.makeConstraints {
            $0.top.equalTo(self.textFieldStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        
        self.appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(self.loginButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        
        self.firebaseLoginStackView.snp.makeConstraints {
            $0.top.equalTo(self.signUpButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        self.firebaseAppleLoginButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
        }
        
        self.firebaseGoogleLoginButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
        }
       
        
        self.signUpButton.snp.makeConstraints {
            $0.top.equalTo(self.appleLoginButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(16)
        }
        
       
        
    }
   
    
    @objc func appleLoginButtonTapped(_: UITapGestureRecognizer) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email] // 얻을 수 있는 값 : 이름과 이메일

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    @objc func signUpButtonTapped(_: UITapGestureRecognizer) {
//        if self.spinnerView.isAnimating == true {
//            self.spinnerView.stopAnimating()
//        } else {
//            self.spinnerView.startAnimating()
//        }
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print("🛑", error?.localizedDescription as Any)
                return
            }
            print(authResult as Any)
            
            self.emailTextField.text?.removeAll()
            self.passwordTextField.text?.removeAll()
        }
       
    }
    
    @objc func firebaseGoogleSignInButtonTapped(_: UITapGestureRecognizer) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
               let signInConfig = GIDConfiguration.init(clientID: clientID)
               
             GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
               guard error == nil else { return }

               guard let authentication = user?.authentication else { return }
               let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
               // access token 부여 받음
               
               // 파베 인증정보 등록
               Auth.auth().signIn(with: credential) {result, error in
                   // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                   if error != nil {
                       
                       print("🛑", error?.localizedDescription as Any)
                       return
                   }
                   print(result as Any)
               }
             }
    }
    
    @objc func firebaseAppleSignInButtonTapped(_: UITapGestureRecognizer) {
            startSignInWithAppleFlow()
    }
    
    @objc func loginButtonTapped(_: UITapGestureRecognizer) {
        guard let user = Auth.auth().currentUser else { return }
        print("=== user is already signIn ===")
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

   
    
    
    // <------ firebase -------> //
    // 로그인 요청마다 nonce가 생성, 재전송 공격을 막기 위한 로직
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    // nonce의 sha256해시를 계산, Apple은 이에 대한 응답으로 원래의 값을 전달합니다. Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()
        print(hashString)
      return hashString
    }
    

}

extension AppleLoginViewController: ASAuthorizationControllerDelegate {
    // 성공 후 동작
       func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
           
            switch authorization.credential {
            case let credential as ASAuthorizationAppleIDCredential:
               
//               let idToken = credential.identityToken! // JSON web token, 안전하게 app과 통신
//               let tokeStr = String(data: idToken, encoding: .utf8)
//               print("identitiyToken: ", tokeStr as Any)
//
//               guard let code = credential.authorizationCode else { return } // server와 통신하는 토큰
//               let codeStr = String(data: code, encoding: .utf8)
//               print("authorizationCode :", codeStr as Any)
//
//               // user의 정보 : 최초 로그인에서만 이름과 이메일을 받을 수 있고 그 후에는 ID값만 리턴
//               let user = credential.user
//               let fullName = credential.fullName
//               let email = credential.email
//
//               print("username:", user)
//               print("fullname: ", fullName as Any)
//               print("email: ", email as Any)
//
//               // save in keychain
//               repo.addValueOnKeyChain(value: user, key: USER_IDENTIFIER_STRING)
                
                // <--- firebase 에서의 처리 ---> //
                 guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                  }
                  guard let appleIDToken = credential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                  }
                  guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                  }
                
                 // Initialize a Firebase credential.
                  let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                            idToken: idTokenString,
                                                            rawNonce: nonce)
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { [self] (authResult, error) in
                    if error != nil {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print("🛑", error?.localizedDescription as Any)
                        return
                    }
                    // User is signed in to Firebase with Apple.
                    print(authResult as Any)
                    self.repo.addValueOnKeyChain(value: idTokenString, key: APPLE_ID_TOKEN_STRING)
                    self.repo.addValueOnKeyChain(value: nonce, key: NONCE_STRING)
                 
                    
                }
               
            case let passwordCredential as ASPasswordCredential:
                  // Sign in using an existing iCloud Keychain credential.
               let username = passwordCredential.user
               let password = passwordCredential.password
                
                print("username : \(username) password : \(password)")
                  
                  // For the purpose of this demo app, show the password credential as an alert.
            //               DispatchQueue.main.async {
            //                      self.showPasswordCredentialAlert(username: username, password: password)
            //                  }
                  
            default:
                  break
            }
       }

       // 실패 후 동작
       func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
           print("sign in apple error")
       }
}

extension AppleLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
