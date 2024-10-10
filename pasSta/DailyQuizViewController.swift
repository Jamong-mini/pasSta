//
//  ViewController.swift
//  pasSta
//
//  Created by Jamong on 10/2/24.
//

import UIKit

class DailyQuizViewController: UIViewController {
    
    
    // 문제에 대한 Label
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "What are the keywords to create variables?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let pickAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a Answer"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    // 선택지에 대한 배열 (SwiftData 동적처리 예정)
    var answers: [String] = ["var", "val", "let", "const"]
    
    // 정답 인덱스
    var correctAnswerIndex: Int = 0
    
    // 선택지를 담을 StackView
    let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    // 선택지 버튼 배열
    var optionButton: [UIButton] = []
    
    // 제출 버튼
    let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Submit"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        let button = UIButton(configuration: config)
        button.isEnabled = false // 처음에는 비활성화
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 현재 선택된 답안 인덱스
    var selectedAnswerIndex: Int? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기본 설정
        view.backgroundColor = .white
        navigationItem.title = "Daily Quiz"
        
        setupUI()
    }
    
    // UI 배치 함수
    private func setupUI() {
        
        // 1. 상단 지문
        let questionContainerView = UIView()
        view.addSubview(questionContainerView)
        questionContainerView.addSubview(questionLabel)
        
        questionContainerView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: questionContainerView.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainerView.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: questionContainerView.trailingAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: questionContainerView.bottomAnchor)
        ])
        
        // 2. 중간 선택지 부분
        let answerContainerView = UIView()
        view.addSubview(answerContainerView)
        answerContainerView.addSubview(pickAnswerLabel)
        answerContainerView.addSubview(optionsStackView)
        
        answerContainerView.translatesAutoresizingMaskIntoConstraints = false
        pickAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            answerContainerView.topAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: 24),
            answerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pickAnswerLabel.topAnchor.constraint(equalTo: answerContainerView.topAnchor),
            pickAnswerLabel.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor),
            pickAnswerLabel.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor),
            
            optionsStackView.topAnchor.constraint(equalTo: pickAnswerLabel.bottomAnchor, constant: 20),
            optionsStackView.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: answerContainerView.bottomAnchor)
        ])
        
        // 선택지 버튼들을 스택뷰에 추가
        // eumerated(): 인덱스와 값을 동시에 반환하는 메서드
        for (index, answer) in answers.enumerated() {
            let button = createCustomRadioButton(title: answer, tag: index)
            // addArragedSubview: 자동으로 레이아웃에 맞게 정렬
            optionsStackView.addArrangedSubview(button)
            optionButton.append(button)
        }
        
        // 3. 하단 제출 버튼 부분
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: answerContainerView.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    // 커스텀 라디오 버튼 생성 함수
    private func createCustomRadioButton(title: String, tag: Int) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        // 선택되지 않은 상태에서는 텍스트와 circle 이미지가 모두 다크 그레이
        config.title = title
        config.baseForegroundColor = .darkGray
        config.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate) // 템플릿으로 설정해서 tintColor가 적용됨
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let button = UIButton(configuration: config)
        button.tintColor = .darkGray // circle 이미지는 다크 그레이
        button.tag = tag
        button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        return button
    }
    
    
    @objc private func optionSelected(_ sender: UIButton) {
        selectedAnswerIndex = sender.tag
        
        // 모든 버튼의 상태를 초기화
        optionButton.forEach { button in
            var config = button.configuration
            config?.baseForegroundColor = .darkGray// 기본 상태의 텍스트는 다크 그레이
            config?.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.darkGray) // 기본 원형 이미지
            button.configuration = config
        }
        
        // 선택된 버튼만 텍스트는 검은색, circle 이미지는 파란색으로 변경
        var selectedConfig = sender.configuration
        selectedConfig?.baseForegroundColor = .black // 선택된 상태의 텍스트는 검은색
        selectedConfig?.image = UIImage(systemName: "largecircle.fill.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue) // 선택된 원형 이미지
        sender.configuration = selectedConfig
        
        submitButton.isEnabled = true
    }
    
    @objc private func submitButtonTapped() {
        guard let selectedAnswerIndex = selectedAnswerIndex else { return }
        
        let isCorrect = selectedAnswerIndex == 0
        if isCorrect {
            // 맞았을 때 알럿 띄우기
            let alert = UIAlertController(title: "Congratulations 🎉", message: "To solve the next quiz, touch on Next Quiz.", preferredStyle: .alert)
            
            let goHomeAction = UIAlertAction(title: "Go Home", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            let nextQuizAction = UIAlertAction(title: "Next Quiz", style: .default) { _ in
                //                let nextQuizVC = NextQuizViewController()
                //                self.navigationController?.pushViewController(nextQuizVC, animated: true)}
            }
            alert.addAction(goHomeAction)
            alert.addAction(nextQuizAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            // 틀렸을 때의 알럿
            let alert = UIAlertController(title: "Result", message: "Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
