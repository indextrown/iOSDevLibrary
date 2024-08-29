//
//  ViewController.swift
//  iOSDevLibrary
//
//  Created by 김동현 on 8/11/24.
//


import UIKit
import SnapKit
import Combine

class FirstViewController: UIViewController {
    
    var checked: Bool = false
    
    // MARK: - Combine을 위한 구독 저장소
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - 인스턴스를 저장할 변수
    private var kakaoAuthVM = KakaoAuthVM.shared // 싱글톤 인스턴스
    
    // MARK: - 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside) // 버튼 누르면 동작
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        setupBindings()
    }
    
    func makeUI() {
        // 네비게이션 바 (상단)
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "Main"
        
        // 버튼 추가
        view.addSubview(backButton)
        
        // 버튼 오토레이아웃 설정
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 70),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Combine 바인딩 설정
    func setupBindings() {
        kakaoAuthVM.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                guard let self = self else { return }
                self.handleLoginStatus(isLoggedIn: isLoggedIn)
            }
            .store(in: &subscriptions)
    }
    
    private func handleLoginStatus(isLoggedIn: Bool) {
        if isLoggedIn {
            hideLoginScreen()
            checked = true
            checkProfileAndUpdateUI()
        } else {
            print("로그인 화면 표시")
            checkAndShowLoginScreen()
        }
    }
    
    private func checkProfileAndUpdateUI() {
        kakaoAuthVM.$hasProfile
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasProfile in
                guard let self = self else { return }
                self.updateUI(hasProfile: hasProfile)
            }
            .store(in: &subscriptions)
    }
    
    private func updateUI(hasProfile: Bool) {
        if checked {
            if hasProfile {
                //print("프로필이 존재해서 홈으로 이동")
                // 홈 화면으로 이동하는 코드
            } else {
                print("로그인은 성공하였으나 닉네임이 없는 상태")
                // 닉네임 설정 화면으로 이동하는 코드
                presentProfileVC()
            }
        } else {
            print("테스트중")
        }
    }
    
    // MARK: - 로그인 화면이 이미 표시되지 않은 경우 로그인 화면을 표시
    private func checkAndShowLoginScreen() {
        if presentedViewController == nil {
            showLoginScreen()
        }
    }
    
    // MARK: - 로그인 화면을 표시하는 메서드
    private func showLoginScreen() {
        let loginVC = LoginViewController() // 실제 로그인 화면 뷰 컨트롤러로 교체
        loginVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    
    // MARK: - 로그인 화면을 숨기는 메서드
    private func hideLoginScreen() {
        if presentedViewController is LoginViewController {
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 뒤로가기 버튼 액션
    @objc func backButtonTapped() {
        dismiss(animated: false, completion: nil)
        KakaoAuthVM.shared.KakaoLogout()
        presentLoginVC()
        checked = false
    }
    
    // MARK: - 로그인 화면 띄우기
    func presentLoginVC() {
        let loginVC = LoginViewController() // 인스턴스화하여 로그인 화면 뷰 생성
        loginVC.modalPresentationStyle = .fullScreen // 전체 화면
        DispatchQueue.main.async { [weak self] in
            self?.present(loginVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - 프로필 화면 띄우기
    func presentProfileVC() {
        let ProfileVC = FifthViewController()
        ProfileVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(ProfileVC, animated: false, completion: nil)
        }
    }
}


