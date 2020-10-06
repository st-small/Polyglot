//
//  TestViewController.swift
//  Polyglot
//
//  Created by Stanly Shiyanovskiy on 06.10.2020.
//

import UIKit

public final class TestViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var prompt: UILabel!
    
    // MARK: - Data
    public var words: [String]!
    private var questionCounter = 0
    private var showingQuestion = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextTapped))
        words.shuffle()
        title = "TEST"

        stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        stackView.alpha = 0
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // the view was just shown - start asking a question now
        askQuestion()
    }
    
    @objc
    private func nextTapped() {
        // move between showing question and answer
        showingQuestion = !showingQuestion

        if showingQuestion {
            // we should be showing the question – reset!
            prepareForNextQuestion()
        } else {
            // we should be showing the answer – show it now, and set the color to be green
            prompt.text = words[questionCounter].components(separatedBy: "::")[0]
            prompt.textColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        }
    }

    private func askQuestion() {
        // move the question counter one place
        questionCounter += 1
        if questionCounter == words.count {
            // wrap it back to 0 if we've gone beyond the size of the array
            questionCounter = 0
        }

        // pull out the French word at the current question position
        prompt.text = words[questionCounter].components(separatedBy: "::")[1]

        // animate the stack view in using a spring animation
        let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5) {
            self.stackView.alpha = 1
            self.stackView.transform = CGAffineTransform.identity
        }

        animation.startAnimation()
    }
    
    private func prepareForNextQuestion() {
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [unowned self] in
            self.stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.stackView.alpha = 0
        }

        animation.addCompletion { [unowned self] position in
            self.prompt.textColor = UIColor.black
            self.askQuestion()
        }

        animation.startAnimation()
    }
}
