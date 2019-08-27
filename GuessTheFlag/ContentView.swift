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
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach((0...2), id: \.self) { number in
                    Image(self.countries[number])
                        .border(Color.black, width: 1)
                        .onTapGesture {
                            self.flagTapped(number)
                        }
                }
                Spacer()
            }
                .navigationBarTitle(Text(countries[correctAnswer].uppercased()))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                            self.askQuestion()
                        })
                }
        }
    }
    
    func flagTapped(_ tag: Int) {
        if tag == correctAnswer {
            score += 1
            alertTitle = "Correct"
        } else {
            score -= 1
            alertTitle = "Wrong"
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
