//
//  SplashScreenViewController.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/25.
//

import UIKit
import AuthenticationServices

class SplashScreenViewController: UIViewController {


    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchScreen.png")
        return imageView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        setLayout()
        
        checkAlreadySignIn()
    }
    
    func addSubViews() {
       self.view.addSubview(backgroundImageView)
    }
    
    func setLayout() {
        self.backgroundImageView.snp.makeConstraints {
          // self.nameLbl은 superView로부터 center에 위치함
            $0.width.height.equalToSuperview()
        }
        
    }
    
    func checkAlreadySignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        // 해당 ID의 애플로그인 확인
        let keychainRepository = KeyChainRepository()
        let userId = keychainRepository.readValueOnKeyChain(key: USER_IDENTIFIER_STRING) ?? ""
        
        appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, error) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    print("해당 ID는 연동되어 있습니다.")
                    let secondVC = ViewController()
                    self.navigationController?.pushViewController(secondVC, animated: true)
                case .revoked:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    print("해당 ID는 연동되어 있지 않습니다.")
                    let secondVC = AppleLoginViewController()
                    self.navigationController?.pushViewController(secondVC, animated: true)
                case .notFound:
                    // The Apple ID credential is either was not found, so show the sign-in UI.
                    print("해당 ID를 찾을 수 없습니다.")
                    let secondVC = AppleLoginViewController()
                    self.navigationController?.pushViewController(secondVC, animated: true)
                default:
                    break
                }
            }
           }
        
        // 설정에서 appleLogin을 거부하도록 바꿀 경우의 처리
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { _ in
            print("Revoked Notification")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
