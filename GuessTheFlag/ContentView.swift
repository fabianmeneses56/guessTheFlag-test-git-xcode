//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Edison Fabian Meneses salamanca on 3/06/24.
//

import SwiftUI

struct FlagImage: View {
    
    var countryNumber:String
    
    var body: some View {
        Image(countryNumber)
            .clipShape(.capsule)
            .shadow(radius: 5)
            
    }
    
    init(_ countryNumber: String) {
        self.countryNumber = countryNumber
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var endGame = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionsCount = 0
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var numberFlagSelected = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing:15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            numberFlagSelected = number
                            withAnimation {
                                opacity -= 0.25
                                animationAmount += 360
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
//                            Image(countries[number])
//                                .clipShape(.capsule)
//                                .shadow(radius: 5)
                        }
                        .rotation3DEffect(.degrees(numberFlagSelected == number  ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                        .opacity(numberFlagSelected != number ? opacity : 1.0)
                        .scaleEffect(numberFlagSelected != number ? opacity : 1.0)
                        .animation(.bouncy , value: opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("\(questionsCount) of 8")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                HStack {
                    Text("Correct \(userScore)")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 25))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: userScore)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        
        .alert("Your final score is \(userScore)!", isPresented: $endGame) {
            Button("Reset Game", action: resetGame)
        }
    }
    
    func flagTapped(_ number: Int) {
        print(number)
        if number == correctAnswer {
            userScore += 1
            scoreTitle = "Correct"
           
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        questionsCount += 1
        showingScore = true
    }
    func askQuestion() {
        if(questionsCount == 8){
            endGame = true
        }
        opacity = 1.0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func resetGame() {
        endGame = false
        questionsCount = 0
        userScore = 0
        scoreTitle = ""
        askQuestion()
    }
}

#Preview {
    ContentView()
}
