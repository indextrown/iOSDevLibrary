//
//  KakaoAuthVM.swift
//  iOSDevLibrary
//
//  Created by 김동현 on 8/12/24.
//

import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKAuth


class KakaoAuthVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    // 로그인 상태 여부
    @Published var isLoggedIn: Bool = false
    
    lazy var loginStatusInfo: AnyPublisher<String?, Never> = $isLoggedIn.compactMap{$0 ? "로그인 상태" : "로그아웃 상태"}.eraseToAnyPublisher()
    
    init() {
        print("KakaoAuthVM - handleKakaoLogin() called")
    }
    
    // 카카오톡 앱으로 로그인 인증
    func kakaoLoginWithApp() async -> Bool {
        
        await withCheckedContinuation { continuation in
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
                // 카카오톡 앱으로 로그인 인증
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoTalk() success")
                        
                        // do something
                        _ = oauthToken
                        
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    func kakaoLoginWithAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success")
                    
                    // do something
                    _ = oauthToken
                    
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor // main 스레드에서 작동하도록
    func KakaoLogin() {
        print("KakaoAuthVM - handleKakaoLogin() called")
        
        // asyhc/await사용시 필수
        Task {
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 앱으로 로그인 인증
                isLoggedIn = await kakaoLoginWithApp()
                
            } else { // 카톡이 설치가 안되어 있으면
                // 카카오 계정으로 로그인
                isLoggedIn = await kakaoLoginWithAccount()
            }
        }
        
        
        
    } // login
    
    
    
    @MainActor
    func KakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                self.isLoggedIn = false
            }
        }
    } // logout
    
    
    
    
    
    // logout
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
}













//
//import Foundation
//import Combine
//import KakaoSDKUser
//import KakaoSDKAuth
//
//class KakaoAuthVM: ObservableObject {
//    var subscriptions = Set<AnyCancellable>()
//    
//    @Published var isLoggedIn: Bool = false
//    @Published var userNickname: String? = nil
//    
//    lazy var loginStatusInfo: AnyPublisher<String?, Never> = $isLoggedIn
//        .compactMap { $0 ? "로그인 상태" : "로그아웃 상태" }
//        .eraseToAnyPublisher()
//    
//    init() {
//        print("KakaoAuthVM - handleKakaoLogin() called")
//    }
//    
//    // 사용자 정보 가져오기
//    func fetchUserInfo() {
//        UserApi.shared.me { [weak self] (user, error) in
//            if let error = error {
//                print("Failed to fetch user info: \(error)")
//            } else {
//                if let user = user {
//                    self?.userNickname = user.kakaoAccount?.profile?.nickname
//                    print("User nickname: \(self?.userNickname ?? "No nickname")")
//                }
//            }
//        }
//    }
//    
//    func kakaoLoginWithApp() async -> Bool {
//        await withCheckedContinuation { continuation in
//            if (UserApi.isKakaoTalkLoginAvailable()) {
//                UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
//                    if let error = error {
//                        print(error)
//                        continuation.resume(returning: false)
//                    } else {
//                        print("loginWithKakaoTalk() success")
//                        self?.fetchUserInfo()
//                        continuation.resume(returning: true)
//                    }
//                }
//            }
//        }
//    }
//    
//    func kakaoLoginWithAccount() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
//                if let error = error {
//                    print(error)
//                    continuation.resume(returning: false)
//                } else {
//                    print("loginWithKakaoAccount() success")
//                    self?.fetchUserInfo()
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
//    
//    @MainActor
//    func KakaoLogin() {
//        Task {
//            if (UserApi.isKakaoTalkLoginAvailable()) {
//                isLoggedIn = await kakaoLoginWithApp()
//            } else {
//                isLoggedIn = await kakaoLoginWithAccount()
//            }
//        }
//    }
//    
//    @MainActor
//    func KakaoLogout() {
//        Task {
//            if await handleKakaoLogout() {
//                self.isLoggedIn = false
//                self.userNickname = nil
//            }
//        }
//    }
//    
//    func handleKakaoLogout() async -> Bool {
//        await withCheckedContinuation { continuation in
//            UserApi.shared.logout { (error) in
//                if let error = error {
//                    print(error)
//                    continuation.resume(returning: false)
//                } else {
//                    print("logout() success.")
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
//}
