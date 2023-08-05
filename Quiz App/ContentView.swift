//
//  ContentView.swift
//  Quiz App
//
//  Created by Muhammed Aiz on 05/08/2023.
//

import SwiftUI

struct Question {
    let questionNumber: Int
    let questionText: String
    let answers: [String]
    let correctAnswer: Int
}



struct ContentView: View {
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showResult = false
    @State private var progress: Float = 0.0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var selectedAnswerIndex: Int? = nil
    
    let questions = [
        Question(questionNumber: 1, questionText: "Which country won the FIFA World Cup in 2018?", answers: ["Brazil", "Germany", "France"], correctAnswer: 2),
                        Question(questionNumber: 2, questionText: "Who is the all-time leading goal scorer in FIFA World Cup history?", answers: ["Lionel Messi", "Cristiano Ronaldo", "Marta", "Miroslav Klose"], correctAnswer: 3),
        Question(questionNumber: 3, questionText: "Which club has won the most UEFA Champions League titles?", answers: ["Barcelona", "Real Madrid", "Liverpool", "AC Milan"], correctAnswer: 1),
                        Question(questionNumber: 4, questionText: "Which player has won the most FIFA World Cup titles?", answers: ["Ronaldo Nazario", "Pele", "Diego Maradona", "Zinedine Zidane"], correctAnswer: 1),
                        Question(questionNumber: 5, questionText: "Which country won the first FIFA World Cup in 1930?", answers: ["Argentina", "Brazil", "Uruguay"], correctAnswer: 2),
                        Question(questionNumber: 6, questionText: "Who is the all-time leading scorer in the UEFA Champions League?", answers: ["Cristiano Ronaldo", "Lionel Messi", "Michel Platini", "Robert Lewandowski"], correctAnswer: 0),
                        Question(questionNumber: 7, questionText: "In which year did Cristiano Ronaldo transfer from Real Madrid to Juventus?", answers: [" 2017", " 2018", " 2019", "2020"], correctAnswer: 1),
                        Question(questionNumber: 8, questionText: "In which season did Cristiano Ronaldo score a record 17 goals in a single UEFA Champions League campaign?", answers: [" 2012-2013", " 2013-2014", " 2014-2015", "2015-2016"], correctAnswer: 3),
                        Question(questionNumber: 9, questionText: "Which country's national team did Cristiano Ronaldo make his international debut against?", answers: [" Spain", " Germany", " England", "Kazakhstan"], correctAnswer: 0),
                        Question(questionNumber: 10, questionText: "Who won the Golden Boot award for being the top scorer in the 2014 ", answers: [" Cristiano Ronaldo", "  Lionel Messi", " Neymar Jr.", "James Rodriguez"], correctAnswer: 3),
    ]
    
    var body: some View {
        VStack {
            if currentQuestion < questions.count {
                QuestionView(question: questions[currentQuestion], selectedAnswerIndex: $selectedAnswerIndex, onAnswerSelected: checkAnswer)
                    .padding()
                
                ProgressView(value: progress, total: Float(questions.count))
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .accentColor(.red)
                
                ScoreView(score: score)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
                if showResult {
                    Text("The correct answer is: \(questions[currentQuestion].answers[questions[currentQuestion].correctAnswer])")
                        .padding()
                }
                
                if selectedAnswerIndex != nil {
                    Button(action: nextQuestion, label: {
                        Text("Next Question")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    })
                    .padding(.bottom, 20)
                }
            } else {
                ResultView(score: score, totalQuestions: questions.count, onRestartTapped: restartQuiz)
                    .padding()
            }
        }
        .onAppear(perform: {
            updateProgress()
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    func checkAnswer(_ answer: Int) {
        let question = questions[currentQuestion]
        if answer == question.correctAnswer {
            score += 1
            showAlert(title: "Correct!", message: "Well done!")
        } else {
            showAlert(title: "Wrong!", message: "Try again!")
        }
        selectedAnswerIndex = answer
        showResult = true
        updateProgress()
    }
    
    func nextQuestion() {
        selectedAnswerIndex = nil
        showResult = false
        currentQuestion += 1
        updateProgress()
    }
    
    func updateProgress() {
        progress = Float(currentQuestion)
    }
    
    func restartQuiz() {
        currentQuestion = 0
        score = 0
        selectedAnswerIndex = nil
        showResult = false
        updateProgress()
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct QuestionView: View {
    let question: Question
    @Binding var selectedAnswerIndex: Int?
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Question \(question.questionNumber):")
                .font(.headline)
                .padding()
            
            Text(question.questionText)
                .font(.headline)
                .padding()
            
            ForEach(0..<question.answers.count, id: \.self) { index in
                Button(action: {
                    if selectedAnswerIndex == nil {
                        selectedAnswerIndex = index
                        onAnswerSelected(index)
                    }
                }, label: {
                    Text(question.answers[index])
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedAnswerIndex == index ? (index == question.correctAnswer ? Color.green : Color.red) : Color.red)
                        .cornerRadius(8)
                })
                .padding(.bottom, 8)
                .disabled(selectedAnswerIndex != nil)
            }
            Spacer()
        }
    }
}

struct ScoreView: View {
    let score: Int
    
    var body: some View {
        HStack {
            Text("Score:")
                .font(.headline)
            Text("\(score)")
                .font(.title)
                .foregroundColor(.red)
        }
    }
}

struct ResultView: View {
    let score: Int
    let totalQuestions: Int
    let onRestartTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Quiz finished!")
                .font(.title)
                .padding()
            
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 20)
                    .opacity(0.3)
                Circle()
                    .trim(from: 0.0, to: CGFloat(score) / CGFloat(totalQuestions))
                    .stroke(Color.red, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 200, height: 200)
            .padding()
            
            Text("You got \(score) out of \(totalQuestions) correct!!!")
                .font(.headline)
                .padding()
            
            Button(action: {
                onRestartTapped()
            }, label: {
                Text("Restart Quiz")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

