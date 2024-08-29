//
//  MyFirestore.swift
//  Banchango
//
//  Created by 김동현 on 8/28/24.
//

import FirebaseFirestore


// MARK: - Firestore와의 상호작용 예시
final class MyFirestore {
    // MARK: - Singleton
    static let shared = MyFirestore()
    
    private let db = Firestore.firestore()
    
    // MARK: - Singleton
    private init() {}
    
    // documentListener를 전역으로 선언해놓고 언제든지 리스너를 제거할 수 있도록 설정
    private var documentListener: ListenerRegistration?
    
    
    
    // 사용자 정보 가져오기
    func getUser(uid: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        db.collection("user").document(uid).getDocument { document, error in
            completion(document, error)
        }
    }
    
    // 사용자 정보 업로드
    func saveProfile(uid: String, nickname: String, birthDate: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": uid,
            "nickname": nickname,
            //"age": age,
            "birthDate": birthDate,
            "registerDate": Timestamp(date: Date()) // Firestore에서 사용하는 Timestamp 형식
        ]
        
        db.collection("user").document(uid).setData(data, merge: true, completion: completion)
    }

    
    func saveUser(uid: String, email: String?, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": uid,
            "email": email ?? "No email provided"
        ]
        
        db.collection("user").document(uid).setData(data, merge: true, completion: completion)
    } 
    
    /*
    
    // 메시지 추가
    func addMessage(_ message: Message, completion: @escaping (Error?) -> Void) {
        guard let data = message.asDictionary else {
            completion(NSError(domain: "EncodingError", code: -1, userInfo: nil))
            return
        }
        db.collection("messages").addDocument(data: data, completion: completion)
    }
    
    // 메시지 저장 (특정 문서 ID에 저장하거나 업데이트)
    func saveMessage(_ message: Message, withID id: String, completion: @escaping (Error?) -> Void) {
        guard let data = message.asDictionary else {
            completion(NSError(domain: "EncodingError", code: -1, userInfo: nil))
            return
        }
        db.collection("messages").document(id).setData(data, merge: true, completion: completion)
    }
    
    // 실시간 업데이트를 리스닝하는 메서드
    func listenToMessage(withID id: String, completion: @escaping (Message?, Error?) -> Void) {
        documentListener = db.collection("messages").document(id).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil, error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let message = try JSONDecoder().decode(Message.self, from: jsonData)
                completion(message, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    // 리스너 제거
    func removeListener() {
        documentListener?.remove()
        documentListener = nil
    }
    
    */

    
}

