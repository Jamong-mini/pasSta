import UIKit

class DailyQuizViewController: UIViewController {
    
    // 외부 파일에서 가져온 UI 컴포넌트들 (타이포 수정)
    let questionLabel = QuizUIComponents.createQuestionLabel()
    let pickAnswerLabel = QuizUIComponents.createPickAnswerLabel()
    let optionsStackView = QuizUIComponents.createOptionsStackView()
    lazy var submitButton = QuizUIComponents.createSubmitButton(target: self, action: #selector(submitButtonTapped))
    
    // 퀴즈 로직
    var quizLogic = QuizLogicManager()
    
    var correctAnswerIndex: Int = 0
    
    // 선택지에 대한 배열 (SwiftData 동적처리 예정)
    var answers: [String] = ["var", "val", "let", "const"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기본 설정
        view.backgroundColor = .white
        navigationItem.title = "Daily Quiz"
        
        setupUI()
    }
    
    // UI 배치 함수
    private func setupUI() {
        
        // 초기 비활성화 설정
        submitButton.isEnabled = false
        
        // 1. 상단 지문
        let questionContainerView = UIView()
        view.addSubview(questionContainerView)
        questionContainerView.addSubview(questionLabel)
        setupQuestionContainer(questionContainerView)
        
        // 2. 중간 선택지 부분
        let answerContainerView = UIView()
        view.addSubview(answerContainerView)
        answerContainerView.addSubview(pickAnswerLabel)
        answerContainerView.addSubview(optionsStackView)
        setupAnswerContainer(answerContainerView)
        
        // 선택지 버튼들을 스택뷰에 추가
        for (index, answer) in answers.enumerated() {
            let button = quizLogic.createCustomRadioButton(title: answer, tag: index, target: self, action: #selector(optionSelected(_:)))
            optionsStackView.addArrangedSubview(button)
            quizLogic.optionButtons.append(button)
        }
        
        // 3. 하단 제출 버튼 부분
        view.addSubview(submitButton)
        setupSubmitButton()
    }
    
    
    // UI 레이아웃 설정
    private func setupQuestionContainer(_ container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func setupAnswerContainer(_ container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        pickAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickAnswerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            pickAnswerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            pickAnswerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            optionsStackView.topAnchor.constraint(equalTo: pickAnswerLabel.bottomAnchor, constant: 20),
            optionsStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func setupSubmitButton() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        quizLogic.optionSelected(sender)
        
        // 답안 선택 시 submit 버튼 활성화
        submitButton.isEnabled = true
    }
    
    @objc private func submitButtonTapped() {
        print("버튼 누름")
        
        guard let selectedAnswerIndex = quizLogic.selectedAnswerIndex else {
            let alert = UIAlertController(title: "Error", message: "Please select an answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let isCorrect = selectedAnswerIndex == quizLogic.correctAnswerIndex
        if isCorrect {
            print("isCorrect")
            let alert = UIAlertController(title: "Congratulations 🎉", message: "You got it right!", preferredStyle: .alert)
            
            let goHomeAction = UIAlertAction(title: "Go Home", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            let nextQuizAction = UIAlertAction(title: "Next Quiz", style: .default) { _ in
                // 다음 퀴즈 로드 로직
            }
            
            alert.addAction(goHomeAction)
            alert.addAction(nextQuizAction)
            present(alert, animated: true, completion: nil)
        } else {
            print("incorrect")
            let alert = UIAlertController(title: "Oops!", message: "Wrong answer.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
