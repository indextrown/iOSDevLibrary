# 📲 SNS Login Pipeline

많은 SNS 로그인 관련 자료들이 존재하지만, 로그인 후 프로필 정보와 닉네임을 Firebase Database에 저장하는 방법에 대한 정보는 충분하지 않습니다.   
이 README에서는 이러한 기능을 직접 구현하고자 하는 방법을 소개합니다.

## 🌐 기존 방법의 한계

Firebase를 활용한 간단한 앱에서 사용자가 로그인하면 고유한 키(UID)가 생성됩니다.   
이 UID를 통해 사용자에게 필요한 메타정보를 저장할 수 있습니다.   
그러나, UID만을 저장하는 단순한 구조로 인해 사용자 정보를 풍부하게 관리하기 어렵습니다.

### 기존 방식의 디렉터리 구조

```plaintext
Users
├── UID_1
├── UID_2
├── UID_3
```

### 한계점
- **단순 구조**: UID만을 저장하는 단순한 구조로, 추가적인 사용자 메타데이터가 포함되지 않아 사용자 정보를 풍부하게 관리하기 어렵습니다.

## 🚀 목표

사용자에 대한 추가 정보(예: 프로필, 닉네임 등)를 효과적으로 관리하기 위해, Firebase Database에 `Users` 테이블을 설계하고 이를 활용하여 프로필 정보와 닉네임을 저장하는 시스템을 구현할 계획입니다.

### 새로운 방식의 디렉터리 구조

```plaintext
Users
├── UID_1
│   ├── nickname: "user1_nickname"
│   └── profile: "user1_profile_url"
├── UID_2
│   ├── nickname: "user2_nickname"
│   └── profile: "user2_profile_url"
├── UID_3
│   ├── nickname: "user3_nickname"
│   └── profile: "user3_profile_url"
```

### 설명

- **기존 방식의 디렉터리 구조**: UID만을 저장하는 단순한 구조로, 추가적인 사용자 메타데이터가 없습니다.
- **새로운 방식의 디렉터리 구조**: UID 아래에 닉네임과 프로필 정보와 같은 메타데이터를 함께 저장하여, 더 풍부한 사용자 정보를 관리할 수 있습니다.

이 문서는 Firebase Database에서 사용자 데이터를 관리하는 방법을 명확하게 설명하며, 기존 방식과 새로운 방식을 시각적으로 비교하여 이해를 돕습니다.

---

![SNS Login Pipeline](https://github.com/user-attachments/assets/203bae9a-781a-434e-bc76-2fcc17c4082a)


<!--<img width="623" alt="스크린샷 2024-08-11 오전 12 09 27" src="https://github.com/user-attachments/assets/203bae9a-781a-434e-bc76-2fcc17c4082a">-->
