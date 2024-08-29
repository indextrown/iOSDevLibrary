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
    
    // MARK: - 싱글톤
    static let shared = KakaoAuthVM()
    
    // 로그인 상태 여부
    @Published var isLoggedIn: Bool = false
    @Published var hasProfile: Bool = false
    
    @Published var kakaoUserId: String?
    
  
    
    
    
    
    
    private init() {
        // 3초후에 로그인 상태 변경
    }
    
    // 카카오톡 앱으로 로그인 인증
    func kakaoLoginWithApp() async -> Bool {
        
        await withCheckedContinuation { continuation in
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
                DispatchQueue.main.async {
                    // 카카오톡 앱으로 로그인 인증
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            print(error)
                            continuation.resume(returning: false)
                        }
                        else {
                            print("loginWithKakaoTalk() success")
                            self.fetchUserId() // 카카오ID 가져오기
                            
                            continuation.resume(returning: true)
                        }
                    }
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    func kakaoLoginWithAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoTalk() success")
                        
                        self.fetchUserId() // 카카오ID 가져오기
                        
                        
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
    
    // login
    @MainActor // main 스레드에서 작동하도록 보장
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
    }
    
    // logout
    @MainActor
    func KakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                self.isLoggedIn = false
                // self.hasProfile = false
            }
        }
    }
    
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
    
    // 사용자 ID 가져오기
    private func fetchUserId() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("Error fetching user info: \(error)")
            } else if let user = user {
                // 사용자 ID 저장
                self.kakaoUserId = "\(String(describing: user.id!))"
                print("Kakao User ID: \(self.kakaoUserId!)")
                
                // MARK: - Firestore에서 사용자 검색 및 저장
                self.checkAndSaveUser(uid: self.kakaoUserId!, email: user.kakaoAccount?.email)
            }
        }
    }
    
    private func checkAndSaveUser(uid: String, email: String?) {
        MyFirestore.shared.getUser(uid: uid) { document, error in
            if let document = document, document.exists {
                print("User found in Firestore: \(document.data()!)")
                self.hasProfile = true
            } else {
                print("(출력만)User does not exist in Firestore. Saving new user.")
                self.hasProfile = false
                //self.saveNewUser(uid: uid, email: email)
            }
        }
    }
    
    private func saveNewUser(uid: String, email: String?) {
        MyFirestore.shared.saveUser(uid: uid, email: email) { error in
            if let error = error {
                print("Error saving user to Firestore: \(error)")
            } else {
                print("User successfully saved to Firestore.")
            }
        }
    }
    
    
    
   
    
}





// 사용자 ID 가져오기
/*
private func fetchUserId_regacy() {
    UserApi.shared.me { (user, error) in
        if let error = error {
            print("Error fetching user info: \(error)")
        } else if let user = user {
            // 사용자 ID 저장
            self.kakaoUserId = "\(String(describing: user.id))"
            print("Kakao User ID: \(self.kakaoUserId!)")
        }
    }
}
 */
