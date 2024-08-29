//
//  LoginViewController.swift
//  SocialLogin
//
//  Created by 김동현 on 8/28/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // 싱글톤 인스턴스
    private var kakaoAuthVM = KakaoAuthVM.shared
    
    // 구독자
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //view.backgroundColor = .gray
        makeUI()
    }
    
    // 이미지 뷰 추가
    lazy var logoImage: UIImageView = {
        let img = UIImageView()
        // img.image = UIImage(named: "BanChango")
        // .scaleAspectFit은 이미지의 원본 비율을 유지하면서, 이미지 뷰의 크기에 맞게 축소 또는 확대하여 표시
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 로그인 버튼
    lazy var kakaoLoginButton: UIButton = {
        let btn = UIButton()
        
        // 텍스트 제거 (이미지 단독 사용을 원할 경우)
        btn.setTitle("", for: .normal)

        // 이미지 설정
        btn.setImage(UIImage(named: "kakaoLogin"), for: .normal)
        
        // 버튼의 스타일 설정
        btn.configuration = nil // nil로 설정하여 configuration 스타일을 제거
        btn.imageView?.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        
        // 액션 연결
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
        
    // lazy 키워드를 사용해 지연 초기화된 UIStackView를 생성
    lazy var stackView: UIStackView = {
        // UIStackView 인스턴스 생성
        let stack = UIStackView()
        stack.spacing = 32
        stack.spacing = 8                                           // 스택 뷰의 요소 간 간격 설정 (8 포인트)
        stack.axis = .vertical                                      // 스택 뷰의 축 설정: 수직으로 정렬
        stack.alignment = .center                                   // 스택 뷰의 정렬 설정: 스택 내 요소들을 가운데 정렬
        stack.distribution = .fill                                  // 스택 뷰의 분배 설정: 스택 뷰의 요소들이 뷰의 전체 공간을 채우도록 설정
        stack.translatesAutoresizingMaskIntoConstraints = false     // 오토 레이아웃 제약을 적용할 수 있도록 설정
        return stack
    }()
    
    // ui
    func makeUI() {
        // 다크 모드 설정 무시하고 항상 라이트 모드로 설정
        overrideUserInterfaceStyle = .light
        
        // 배경색을 흰색으로 설정
        view.backgroundColor = .white

        // 이미지 뷰 추가 및 제약 설정
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 350), // 이미지 뷰를 화면 상단에서 200포인트 떨어진 위치에 배치
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // 로그인 버튼 추가 및 제약 설정
        view.addSubview(kakaoLoginButton)
        NSLayoutConstraint.activate([
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100), // 이미지 뷰 하단에서 100포인트 떨어진 위치에 배치
//            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 200),
//            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK:  - 버튼액션
    @objc func loginBtnClicked() {
        print("LoginBtnClicked() called")
        kakaoAuthVM.KakaoLogin()
    }
    
    @objc func logoutBtnClicked() {
        print("logoutBtnClicked() called")
        kakaoAuthVM.KakaoLogout()
    }
}




import SwiftUI
// UIViewControllerRepresentable을 채택하여 UIKit의 UIViewController를 SwiftUI 뷰로 변환합니다.
struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginViewController {
        // LoginViewController의 인스턴스를 생성하고 반환합니다.
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // 업데이트가 필요할 경우 여기서 처리합니다.
    }
}

// PreviewProvider를 사용하여 SwiftUI 미리보기를 설정합니다.
struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewControllerRepresentable()
            .previewDisplayName("Login View Controller Preview")
            .previewLayout(.sizeThatFits) // 미리보기 레이아웃을 설정합니다.
    }
}


