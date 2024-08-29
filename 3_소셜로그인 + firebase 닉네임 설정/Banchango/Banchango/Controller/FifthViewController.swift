//
//  FifthViewController.swift
//  Navigation&Tabbar
//
//  Created by 김동현 on 8/24/24.
//

import UIKit
import Combine
import FirebaseAuth


final class FifthViewController: UIViewController, UITextFieldDelegate {
    
    // 싱글톤 인스턴스
    private var kakaoAuthVM = KakaoAuthVM.shared
    
    // Published 변수 구독
    private var subscriptions = Set<AnyCancellable>()
    
    private let nicknameTextField = UITextField()
    private let birthDateTextField = UITextField()
    private let agreeButton = UIButton(type: .system)
    private let completeButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()
    
    // firebase 관련
    private let uid: String = "" // 사용자의 UID
    private let firestore = MyFirestore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()   // 빈 공간을 눌렀을 때 키보드가 내려가도록 설정
        setupDatePicker()   // MARK: - 생년월일 관련
        setupToolBar()
        overrideUserInterfaceStyle = .light
    }
    
    // MARK: - 네비게이션바 / 탭봐 관련
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationAndTabBar(hidden: true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationAndTabBar(hidden: false, animated: animated)
    }
    private func setNavigationAndTabBar(hidden: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
        tabBarController?.tabBar.isHidden = hidden
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let headerLabel = UILabel()
        headerLabel.text = "BanChango"
        headerLabel.textColor = .black // 글자색 설정
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let guideLabel = UILabel()
        guideLabel.text = "회원가입에 필요한\n정보를 입력해주세요"
        guideLabel.textColor = .black // 글자색 설정
        guideLabel.font = UIFont.boldSystemFont(ofSize: 18)
        guideLabel.numberOfLines = 0
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
        let nicknameLabel = UILabel()
        nicknameLabel.text = "닉네임"
        nicknameLabel.textColor = .black // 글자색 설정
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 50),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
        
        
        nicknameTextField.placeholder = "언제든 바꿀 수 있어요"
        // nicknameTextField.backgroundColor = .white // 배경 색상
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.delegate = self // Set the delegate here
        view.addSubview(nicknameTextField)
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // MARK: - #################################################################
        // 생년월일 입력 필드
        let birthDateLabel = UILabel()
        birthDateLabel.text = "생년월일"
        birthDateLabel.textColor = .black
        birthDateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        birthDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(birthDateLabel)
        NSLayoutConstraint.activate([
            birthDateLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 30),
            birthDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            birthDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        birthDateTextField.placeholder = "생년월일을 선택하세요"
        birthDateTextField.borderStyle = .roundedRect
        birthDateTextField.translatesAutoresizingMaskIntoConstraints = false
        birthDateTextField.delegate = self
        view.addSubview(birthDateTextField)
        NSLayoutConstraint.activate([
            birthDateTextField.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 8),
            birthDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            birthDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        

         
        let agreementLabel = UILabel()
        agreementLabel.text = "서비스 약관 동의 *"
        agreementLabel.textColor = .black // 글자색 설정
        agreementLabel.font = UIFont.boldSystemFont(ofSize: 14)
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreementLabel)
        NSLayoutConstraint.activate([
            agreementLabel.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 80),
            agreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        let agreeGuide = UILabel()
        agreeGuide.text = "동의 체크 후 앱을 이용할 수 있어요"
        agreeGuide.font = UIFont.systemFont(ofSize: 14)
        agreeGuide.textColor = UIColor.gray
        agreeGuide.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreeGuide)
        NSLayoutConstraint.activate([
            agreeGuide.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 5),
            agreeGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreeGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        agreeButton.setImage(UIImage(systemName: "square"), for: .normal)
        agreeButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreeButton)
        NSLayoutConstraint.activate([
            agreeButton.topAnchor.constraint(equalTo: agreeGuide.bottomAnchor, constant: 20),
            agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreeButton.widthAnchor.constraint(equalToConstant: 24),
            agreeButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        let termsLabel = UILabel()
        termsLabel.text = "이용약관 및 개인정보처리방침"
        termsLabel.textColor = .black
        termsLabel.font = UIFont.systemFont(ofSize: 14)
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsLabel)
        NSLayoutConstraint.activate([
            termsLabel.centerYAnchor.constraint(equalTo: agreeButton.centerYAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: agreeButton.trailingAnchor, constant: 8),
        ])
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.backgroundColor = .gray
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 22
        completeButton.isEnabled = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
         
         
    }

    // MARK: - Firestore 저장
    @objc private func completeButtonTapped() {
        guard let userId = kakaoAuthVM.kakaoUserId else {
            print("Kakao User ID가 없습니다.")
            return
        }
        
        let nickname = nicknameTextField.text ?? ""
        let birthDate = birthDateTextField.text ?? ""
        
        firestore.saveProfile(uid: userId, nickname: nickname, birthDate: birthDate) { error in
            if let error = error {
                print("Firestore 저장 오류: \(error.localizedDescription)")
            } else {
                print("정보가 Firestore에 성공적으로 저장되었습니다.")
                self.presentMainVC()
            }
        }
    }
    

    
    @objc private func agreeButtonTapped() {
        agreeButton.isSelected.toggle()
        completeButton.isEnabled = agreeButton.isSelected
        completeButton.backgroundColor = agreeButton.isSelected ? .systemBlue : .gray
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // 제스처 인식기가 빈 공간을 클릭했을 때 동작하도록 설정
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - 사용자가 텍스트 필드 외부를 탭할 때
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Return 키를 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 키보드 내리기
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // MARK: - 날짜 관련
    private func setupDatePicker() {
        // datePickerModed에는 time, date, dateAndTime, countDownTimer가 존재합니다.
        datePicker.datePickerMode = .date
        // datePicker 스타일을 설정합니다. wheels, inline, compact, automatic이 존재합니다.
        datePicker.preferredDatePickerStyle = .wheels
        // 원하는 언어로 지역 설정도 가능합니다.
        datePicker.locale = Locale(identifier: "ko-KR")
        // 현재 날짜를 최대 날짜로 설정
        datePicker.maximumDate = Date()
        // 값이 변할 때마다 동작을 설정해 줌
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        // textField의 inputView가 nil이라면 기본 할당은 키보드입니다.
        birthDateTextField.inputView = datePicker
        // textField에 오늘 날짜로 표시되게 설정
        birthDateTextField.text = dateFormat(date: Date())
    }

    // 값이 변할 때 마다 동작
    @objc func dateChange(_ sender: UIDatePicker) {
        // 값이 변하면 UIDatePicker에서 날자를 받아와 형식을 변형해서 textField에 넣어줍니다.
        birthDateTextField.text = dateFormat(date: sender.date)
    }

    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    // Datapicker에 Done버튼 추가
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandler))
        
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
        birthDateTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneButtonHandler(_ sender: UIBarButtonItem) {
        birthDateTextField.text = dateFormat(date: datePicker.date)
        birthDateTextField.resignFirstResponder()
    }
    
    func presentMainVC() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    
}




import SwiftUI
// UIViewControllerRepresentable을 채택하여 UIKit의 UIViewController를 SwiftUI 뷰로 변환합니다.
struct FifthViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FifthViewController {
        // LoginViewController의 인스턴스를 생성하고 반환합니다.
        return FifthViewController()
    }
    
    func updateUIViewController(_ uiViewController: FifthViewController, context: Context) {
        // 업데이트가 필요할 경우 여기서 처리합니다.
    }
}

// PreviewProvider를 사용하여 SwiftUI 미리보기를 설정합니다.
struct FifthViewController_Previews: PreviewProvider {
    static var previews: some View {
        FifthViewControllerRepresentable()
            .previewDisplayName("Login View Controller Preview")
            .previewLayout(.sizeThatFits) // 미리보기 레이아웃을 설정합니다.
    }
}



