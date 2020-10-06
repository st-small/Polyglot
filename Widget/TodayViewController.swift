//
//  TodayViewController.swift
//  Widget
//
//  Created by Stanly Shiyanovskiy on 06.10.2020.
//

import UIKit
import NotificationCenter

public final class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Data
    private var words = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        if let defaults = UserDefaults(suiteName: "group.com.appwithshare") {
            if let savedWords = defaults.object(forKey: "Words") as? [String] {
                words = savedWords
            }
        }
    }
    
    public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(NCUpdateResult.newData)
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            preferredContentSize = CGSize(width: 0, height: 110)
        } else {
            preferredContentSize = CGSize(width: 0, height: 440)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)

        let word = words[indexPath.row]
        let split = word.components(separatedBy: "::")

        cell.textLabel?.text = split[0]
        cell.detailTextLabel?.text = ""

        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView!.backgroundColor = UIColor(white: 1, alpha: 0.20)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}
