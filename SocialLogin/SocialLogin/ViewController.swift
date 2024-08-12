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
    
    var subscriptions = Set<AnyCancellable>()
    
    // 로그인 여부 라벨
    lazy var kakaoLoginStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        return label
    }()
    
    // 로그인 버튼
//    lazy var kakaoLoginButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그인", for: .normal)
//        btn.setImage(UIImage(named: "kakao_Login"), for: .normal) // 이미지 추가
//        btn.configuration = .filled()
//        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//
//        return btn
//    }()
    lazy var kakaoLoginButton: UIButton = {
        let btn = UIButton()
        
        // 텍스트 제거 (이미지 단독 사용을 원할 경우)
        btn.setTitle("", for: .normal)
        
        // 이미지 설정
        btn.setImage(UIImage(named: "test"), for: .normal)
        
        // 버튼의 스타일 설정
        btn.configuration = nil // `nil`로 설정하여 `configuration` 스타일을 제거
        btn.imageView?.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        
        // 액션 연결
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    
    // 로그아웃 버튼
    lazy var kakaoLogoutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("카카오 로그아웃", for: .normal)
        btn.configuration = .filled()
        
        btn.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    // stack view
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 사용할때 메모리에 올라감
    lazy var kakaoAuthVM: KakaoAuthVM = {KakaoAuthVM()} ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 라벨과 70만큼 공간을 띄우겠다
        kakaoLoginStatusLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
        }
        
        // lazy var 사용이유: 아래 3개를 사용할 때 메모리가 올라간다
        // 스택에 레이블 및 버튼 삽입
        stackView.addArrangedSubview(kakaoLoginStatusLabel)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(kakaoLogoutButton)
        
        setBindings()
        
        
        // root view에 서브 뷰로 stack view를 삽입
        self.view.addSubview(stackView)
        
        // snapKIT: 오토레이아웃 코드 단순화
        // addSubview() 에 대한 constraints 단순화
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }// viewDidLoad
    
    // MARK - 버튼액션
    @objc func loginBtnClicked() {
        print("LoginBtnClicked() called")
        kakaoAuthVM.KakaoLogin()
    }
    
    @objc func logoutBtnClicked() {
        print("logoutBtnClicked() called")
        kakaoAuthVM.KakaoLogout()
    }

} // ViewController

// MARK: - 뷰모델 바인딩
extension ViewController {
    fileprivate func setBindings() {
//        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
//
//            guard let self = self else { return } // 순환 참조 예방
//            self.kakaoLoginStatusLabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
//        }.store(in: &subscriptions)
        
        self.kakaoAuthVM.loginStatusInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: self.kakaoLoginStatusLabel)
            .store(in: &subscriptions)
    }
}


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



