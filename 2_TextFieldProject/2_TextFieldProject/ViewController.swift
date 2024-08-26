//
//  ViewController.swift
//  2_TextFieldProject
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - return 버튼 누르면 키보드 내려간다
    @IBAction func doneButtonTapped(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    
    
    func setup() {
        view.backgroundColor = UIColor.gray
        
        // 키보드 안올라올때 시뮬레이터누르고 상단바 io -> keyboard -> toggle software keyboard
        // 단축키: command + k
        // MARK: - 원하는 키보드타입 설정 가능
        textField.keyboardType = UIKeyboardType.emailAddress
        //textField.keyboardType = UIKeyboardType.numberPad
        
        // MARK: - placeholder: 유저에게 안내를 위한 설정(옵셔널 문자열타입)
        textField.placeholder = "이메일 입력"
        
        // MARK: - 테두리 설정
        textField.borderStyle = .roundedRect
        
        // MARK: - 입력시 클리어버튼 생김
        textField.clearButtonMode = .always
    
        // MARK: textField.returnKeyType = .google
        textField.returnKeyType = .next
        
        // MARK: - textField가 응답 객체가 된다
        // UIWindow객체: 화면을 의미(터치, 마우스 입력 반응처리)
        // 화면에서 먼저 반응할 녀석을 지정해줌
        // 텍스트필드가 first응답 객체가 되면 -> 키보드 올라옴
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* MARK: -  텍스트필드, 뷰컨트롤러 서로 따로 존재 / 텍스트필드 내에 delgate속성존재 = 대리자설정 = 대리자는 뷰컨트롤러
           MARK: - 텍스트필드의 대리자는 뷰컨트롤러임을 의미한다 self는 ViewController를 의미한다 */
        textField.delegate = self // 누가 대리쟈역할할거냐: ViewController
        
        
        // UI 설정
        setup()
    }
    
    // MARK: - 여러 시점 전달
    
    // 선택사항
    // 텍스트필드의 입력을 시작할 때 호출(editing을 시작하지말지 여부를 허락하는것)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true // 어떤 경우에도 허락
    }
    
    // 시점
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        print("유저가 텍스트필드의 입력을 시작했다. 여기에 애니메이션 구현가능")
    }
    
    // x버튼(clear)버튼을 누를 때 논리를 넣어서 필요시에만 동작 가능
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // 무조건 안지우는 로직
        // return false
        // 무조건 지우는 로직
        print(#function)
        return true
    }
    
    // 텍스트필드 글자 내용이 (한글자 한글자)입력되거나 지워질때 호출됨 (허락)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // MARK: - 숫자 입력 방지
        if Int(string) != nil {
            return false
        }
        
        let maxLength = 10
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }

    // 엔터가 눌러지게 허용을 할건데 어떤 조건에 할거냐
    // MARK: - 빈문자열이면 엔터를 못누르도록 설정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        if textField.text == "" {
            textField.placeholder = "Type Somwthing"
            return false
        } else {
            return true
        }
        
    }
    
    // 텍스트필드의 입력이 끝날때 호출 (끝날지 말지를 허락)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드의 입력이 실제 끝났을때 호출(시점)
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        print("유저가 텍스트필드 입력을 끝냈다")
    }
    
    // MARK: - 화면의 탭을 감지하는 메섣 -> 터치가 들어오면 모든 것을 종료
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //textField.endEditing(true)
    }
    
}



// How to limit the number of characters in a text field to 10 characters
