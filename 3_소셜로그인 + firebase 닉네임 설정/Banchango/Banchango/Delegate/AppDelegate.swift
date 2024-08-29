//
//  AppDelegate.swift
//  Banchango
//
//  Created by 김동현 on 8/20/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth // ios 13이상
import Firebase



extension UIView {
    static func applyGlobalAppearance() {
        // 전역 스타일 설정
        //self.appearance().backgroundColor = .white
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    // start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // info파일로 접근해서 KAKAO_NATIVE_APP_KEY 가져온다
        let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""

        // 카카오 SDK 추가
        KakaoSDK.initSDK(appKey: nativeAppKey as! String)
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 색상관련
        //UIView.applyGlobalAppearance()

        return true
    }
    
    // 웹브라우저에서 url이 열리게 되면 카카오로그인 스킴이랑 일치여부 확인후 맞으면 웹뷰를 연다
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    // ios 13이상으로 생성된 프로젝트라면 필수 기입
    // url을 가져와서 url이 카카오 스킴이랑 일치하면 웹뷰를 열어서 인증한다
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

