import Foundation

// 퀴즈 데이터 나타내는 모델
struct Quiz: Codable {
    let question: String
    let answers: [String]
    let correctAnswersIndex: Int
}
