//
//  ViewController.swift
//  iOSDevLibrary
//
//  Created by 김동현 on 8/11/24.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - combine시 필요작업, Combine을 위한 구독 저장소
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - 인스턴스를 저장할 변수
    // private var kakaoAuthVM: KakaoAuthVM?
    private var kakaoAuthVM = KakaoAuthVM.shared // 싱글톤 인스턴스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ViewModel의 isLoggedIn 속성과 바인딩 설정
        setupBinding()
    }
    
    // ViewModel의 isLoggedIn 속성과 바인딩 설정
    func setupBinding() {
        kakaoAuthVM.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                // self가 해제된 경우를 방지
                guard let self = self else { return }
                // 로그인 상태에 따라 UI 업데이트
                self.updateUI(isLoggedIn: isLoggedIn)
            }
            .store(in: &subscriptions) // 구독 저장소에 저장
    }
    
    // 로그인 상태에 따라 UI를 업데이트하는 메서드
    private func updateUI(isLoggedIn: Bool) {
        if isLoggedIn {
            // 로그인 상태일 때
            print("Logged In")
            hideLoginScreen()
        } else {
            // 로그아웃 상태일 때
            print("Logged Out")
            checkAndShowLoginScreen()
        }
    }
    
    // 로그인 화면이 이미 표시되지 않은 경우 로그인 화면을 표시
    private func checkAndShowLoginScreen() {
        if presentedViewController == nil {
            showLoginScreen()
        }
    }
    
    // MARK: - ui비동기    로그인 화면을 표시하는 메서드
    private func showLoginScreen() {
        let loginVC = LoginViewController() // Replace with your actual login view controller
        loginVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loginVC, animated: false, completion: nil)
        }
        
    }
    
    // MARK: - ui비동기    로그인 화면을 숨기는 메서드
    private func hideLoginScreen() {
        if presentedViewController is LoginViewController {
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}


















//
//    var subscriptions = Set<AnyCancellable>()
//    
//
//    
//    // 로그인 버튼
//    lazy var kakaoLoginButton: UIButton = {
//        let btn = UIButton()
//        
//        // 텍스트 제거 (이미지 단독 사용을 원할 경우)
//        btn.setTitle("", for: .normal)
//        
//        // 이미지 설정
//        btn.setImage(UIImage(named: "kakao_login_ico"), for: .normal)
//        
//        // 버튼의 스타일 설정
//        btn.configuration = nil // `nil`로 설정하여 `configuration` 스타일을 제거
//        btn.imageView?.contentMode = .scaleAspectFit
//        btn.backgroundColor = .clear
//        
//        // 액션 연결
//        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        
//        return btn
//    }()
//
//    // 로그아웃 버튼
//    lazy var kakaoLogoutButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그아웃", for: .normal)
//        btn.configuration = .filled()
//        
//        btn.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    
//    
//    // stack view
//    lazy var stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.spacing = 8
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.distribution = .fill
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//    
//    // 사용할때 메모리에 올라감
//    lazy var kakaoAuthVM: KakaoAuthVM = {KakaoAuthVM()} ()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 다크 모드 설정 무시하고 항상 라이트 모드로 설정
//        overrideUserInterfaceStyle = .light
//        
//        // 배경색을 흰색으로 설정
//        view.backgroundColor = .white
//                
//        // 라벨과 70만큼 공간을 띄우겠다
////        kakaoLoginStatusLabel.snp.makeConstraints { make in
////            make.height.greaterThanOrEqualTo(70)
////        }
//        
//        // lazy var 사용이유: 아래 3개를 사용할 때 메모리가 올라간다
//        // 스택에 레이블 및 버튼 삽입
//        //stackView.addArrangedSubview(kakaoLoginStatusLabel)
//        stackView.addArrangedSubview(kakaoLoginButton)
//        stackView.addArrangedSubview(kakaoLogoutButton)
//        
//        setBindings()
//        
//        
//        // root view에 서브 뷰로 stack view를 삽입
//        self.view.addSubview(stackView)
//        
//        // snapKIT: 오토레이아웃 코드 단순화
//        // addSubview() 에 대한 constraints 단순화
//        stackView.snp.makeConstraints { make in
//            make.center.equalTo(self.view)
//        }
//    }// viewDidLoad
//    
//    // MARK - 버튼액션
//    @objc func loginBtnClicked() {
//        print("LoginBtnClicked() called")
//        kakaoAuthVM.KakaoLogin()
//    }
//    
//    @objc func logoutBtnClicked() {
//        print("logoutBtnClicked() called")
//        kakaoAuthVM.KakaoLogout()
//    }

 // ViewController







// MARK: - 뷰모델 바인딩
//extension ViewController {
//    fileprivate func setBindings() {
////        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
////
////            guard let self = self else { return } // 순환 참조 예방
////            self.kakaoLoginStatusLabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
////        }.store(in: &subscriptions)
//        
////        self.kakaoAuthVM.loginStatusInfo
////            .receive(on: DispatchQueue.main)
////            .assign(to: \.text, on: self.kakaoLoginStatusLabel)
////            .store(in: &subscriptions)
//    }
//}


// 디버그로 빌드가 될때
#if DEBUG
import SwiftUI
struct ViewControllerPresentable: UIViewControllerRepresentable {
    
    // 데이터 변경시
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    // uikit뷰를 생성해서 인스턴스를 만들어서 반환
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        // control + command + enter: 미리보기 창 뜸
        // control + command + p: 미리보기 돌리기
        
        // 나의 xcode 미리보기 설정: option + command + enter
        // option + command + 화살표(왼쪽, 오른쪽): 함수 숨기기, 보이기
        ViewControllerPresentable()
    }
}
#endif



