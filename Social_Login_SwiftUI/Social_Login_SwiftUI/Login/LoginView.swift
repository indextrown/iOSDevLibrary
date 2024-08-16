import SwiftUI

struct LoginView: View {
    
    @ObservedObject var kakaoAuthVM: KakaoAuthVM
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                kakaoAuthVM.handleKakaoLogin()
            }) {
                HStack {
                    Image("kakao_login_large_wide")
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(kakaoAuthVM: KakaoAuthVM())
}

