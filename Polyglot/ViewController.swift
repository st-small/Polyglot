//
//  ViewController.swift
//  Polyglot
//
//  Created by Stanly Shiyanovskiy on 06.10.2020.
//

import UIKit

public final class ViewController: UITableViewController {

    // MARK: - Data
    private var words = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 22)!]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "POLYGLOT"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startTest))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "End Test", style: .plain, target: nil, action: nil)

        if let defaults = UserDefaults(suiteName: "group.com.appwithshare") {
            if let savedWords = defaults.object(forKey: "Words") as? [String] {
                words = savedWords
            } else {
                saveInitialValues(to: defaults)
            }
        }
    }

    func saveInitialValues(to defaults: UserDefaults) {
        words.append("bear::l'ours")
        words.append("camel::le chameau")
        words.append("cow::la vache")
        words.append("fox::le renard")
        words.append("goat::la chèvre")
        words.append("monkey::le singe")
        words.append("pig::le cochon")
        words.append("rabbit::le lapin")
        words.append("sheep::le mouton")

        defaults.set(words, forKey: "Words")
    }
    
    private func saveWords() {
        if let defaults = UserDefaults(suiteName: "group.com.appwithshare") {
            defaults.set(words, forKey: "Words")
        }
    }
    
    @objc
    private func addNewWord() {
        // create our alert controller
        let ac = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)

        // add two text fields, one for English and one for French
        ac.addTextField { textField in
            textField.placeholder = "English"
        }

        ac.addTextField { (textField) in
            textField.placeholder = "French"
        }

        // create an "Add Word" button that submits the user's input
        let submitAction = UIAlertAction(title: "Add Word", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            // pull out the English and French words, or an empty string if there was a problem
            let firstWord = ac.textFields?[0].text ?? ""
            let secondWord = ac.textFields?[1].text ?? ""

            // submit the English and French word to the insertFlashcard() method
            self.insertFlashcard(first: firstWord, second: secondWord)
        }

        // add the submit action, plus a cancel button
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // present the alert controller to the user
        present(ac, animated: true)
    }
    
    private func insertFlashcard(first: String, second: String) {
        guard first.count > 0 && second.count > 0 else { return }

        let newIndexPath = IndexPath(row: words.count, section: 0)

        words.append("\(first)::\(second)")
        tableView.insertRows(at: [newIndexPath], with: .automatic)

        saveWords()
    }
    
    @objc
    private func startTest() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Test") as? TestViewController else { return }
        vc.words = words

        navigationController?.pushViewController(vc, animated: true)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)

        let word = words[indexPath.row]
        let split = word.components(separatedBy: "::")

        cell.textLabel?.text = split[0]
        cell.detailTextLabel?.text = ""

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.detailTextLabel?.text == "" {
                let word = words[indexPath.row]
                let split = word.components(separatedBy: "::")
                cell.detailTextLabel?.text = split[1]
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
    }

    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveWords()
    }
}

