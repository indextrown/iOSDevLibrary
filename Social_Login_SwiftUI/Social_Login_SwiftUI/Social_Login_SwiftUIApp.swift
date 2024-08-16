//
//  Social_Login_SwiftUIApp.swift
//  Social_Login_SwiftUI
//
//  Created by 김동현 on 8/15/24.
//

import SwiftUI
//import KakaoSDKCommon
//import KakaoSDKAuth

@main
struct Social_Login_SwiftUIApp: App {
    
    // 기존 방식 채택
    // AppDelegate 사용
    @UIApplicationDelegateAdaptor var appDelegate: MyAppDelegate
    //@UIApplicationDelegateAdaptor(MyAppDelegate.self) var appDelegate
    
    
    
    // 새로운 방식
    //    init() {
    //        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    //        print("App key: \(kakaoAppKey)")
    //
    //        // Kakao SDK 초기화
    //        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    //    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
