//
//  ContentView.swift
//  Social_Login_SwiftUI
//
//  Created by 김동현 on 8/15/24.
//

import SwiftUI

struct ContentView: View {
    
    // 뷰모델을 state로 가져올 때 사용
    @StateObject var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    let loginStatusInfo: (Bool) -> String = { isLoggedIn in
        return isLoggedIn ? "로그인 상태" : "로그아웃 상태"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(loginStatusInfo(kakaoAuthVM.isLoggedIn))
                .padding()
            
            Button(action: {
                kakaoAuthVM.handleKakaoLogin()
            }) {
                HStack {
                    Image("kakao_login_large_wide")
                    
                }
            }
            
            Button("카카오 로그아웃", action: {
                kakaoAuthVM.kakaoLogout()
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
 
