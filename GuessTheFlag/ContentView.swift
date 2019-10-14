//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by H Hugo Falkman on 2019-08-27.
//  Copyright © 2019 H Hugo Falkman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
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
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                
                Text("Your score is \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
            }
        }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(errorMessage + "Your score is \(score)."), dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    })
            }
    }
    
    func flagTapped(_ tag: Int) {
        if tag == correctAnswer {
            score += 1
            alertTitle = "Correct"
            errorMessage = ""
        } else {
            score -= 1
            alertTitle = "Wrong"
            errorMessage = "That's the flag of " + countries[tag].capitalized + ". "
        }
        showingAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
