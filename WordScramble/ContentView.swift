//
//  ContentView.swift
//  WordScramble
//
//  Created by Derek Velzy on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your words", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) {
                        word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                // nil coelecing in case it doesnt return a word
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // make sure theres at least one character in here
        guard answer.count > 0 else { return }
        
        // Extra validation...
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    
// ======================== EXAMPLE FUNCTIONS =========================
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            // use try? to have the error case be turned into an optional value
            if let fileContents = try? String(contentsOf: fileURL) {
                _ = fileContents
            }
        }
    }

    func testStrings() {
        let str1 = "a b c"
        let str2 = """
                    a
                    b
                    c
                    """
        // divides the string into an array
        let letters1 = str1.components(separatedBy: " ")
        let letters2 = str2.components(separatedBy: "\n")
        
        // pull out a random element
        // this creates an optional string because the array could have been empty
        // need to use nil coelecing
        let letter1 = letters1.randomElement()
        let letter2 = letters2.randomElement()
        
        // remove all white space
        _ = letter1?.trimmingCharacters(in: .whitespacesAndNewlines)
        _ = letter2?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func textCheck() {
        // create a spell check
        let word = "swift"
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        _ = misspelledRange.location == NSNotFound
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
