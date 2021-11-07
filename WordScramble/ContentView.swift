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
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // Function gets triggered on onAppear
    func startGame() {
        // If the url exists
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // if there are contents in the url that can be converted to a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // combine the words into an array
                let allWords = startWords.components(separatedBy: "\n")
                // nil coelecing in case it doesnt return a word
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        // for each letter in the given word passed in
        for letter in word {
            // find the index at which the letter appears in the given word
            if let pos = tempWord.firstIndex(of: letter) {
                // if it exists, remove it from the given word
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // make sure theres at least one character in here
        // "guard" is saying:
            // if this expression is valid and truthy, continue
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recongized", message: "You can't just make them up")
            return
        }

        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
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
