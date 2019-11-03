//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by H Hugo Falkman on 2019-08-27.
//  Copyright © 2019 H Hugo Falkman. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    
    @State private var animationAmount = Array(repeating: 0.0, count: 3)
    @State private var opacity = Array(repeating: 1.0, count: 3)
    @State private var isShowing = true
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            
            if isShowing {
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                        
                        Text(countries[correctAnswer].capitalized)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    
                    ForEach((0...2), id: \.self) { number in
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            FlagImage(country: self.countries[number])
                                .rotation3DEffect(
                                    .degrees(self.animationAmount[number]), axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(self.opacity[number])
                        }
                    }
                    
                    Text("Your score is \(score)")
                        .foregroundColor(.white)
                        .font(.title)
                    
                    Spacer()
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .alert(isPresented: $showingAlert.animation(.easeInOut(duration: 5.0 ))) {
                Alert(title: Text(alertTitle), message: Text(errorMessage + "Your score is \(score)."), dismissButton: .default(Text("Continue"), action: askQuestion))
            }
    }
    
    func flagTapped(_ tag: Int) {
        withAnimation(Animation.easeInOut(duration: 0.5).delay(0.3)) {
            if tag == correctAnswer {
                animationAmount[tag] += 360
                for index in 0...2 {
                    opacity[index] = min(opacity[index], 0.25)
                }
                opacity[tag] = 1
                score += 1
                alertTitle = "Correct"
                errorMessage = ""
            } else {
                score -= 2
                alertTitle = "Wrong"
                errorMessage = "That's the flag of " + countries[tag].capitalized + ". "
                opacity[tag] = 0
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.showingAlert = true
            self.timer?.invalidate()
        }
    }
    
    func askQuestion() {
        if alertTitle == "Wrong" { return }
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            isShowing.toggle()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.55, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isShowing.toggle()
            }
            self.timer?.invalidate()
        }
        countries.shuffle()
        opacity = Array(repeating: 1.0, count: 3)
        correctAnswer = Int.random(in: 0...2)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
