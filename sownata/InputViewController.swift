//
//  InputViewController.swift
//  sownata
//
//  Created by Gary Joy on 24/04/2016.
//
//

import UIKit

class InputViewController: UIViewController {

    var logEntry = LogEntry() // This is our Model
    
    override func viewDidLoad() {
        
        logText.layer.cornerRadius = 5.0
        logText.clipsToBounds = true

        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.isNavigationBarHidden = true;

        let times = getTimes()
        for time in times {
            let timeButton = UIButton(type: UIButtonType.system)
            timeButton.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 0.5)
            timeButton.setTitle(time, for: UIControlState())
            timeButton.addTarget(self, action: #selector(InputViewController.selectTime(_:)), for: UIControlEvents.touchUpInside)
            timeStackView.addArrangedSubview(timeButton)
        }

        let nouns = getNouns()
        for noun in nouns {
            let nounButton = UIButton(type: UIButtonType.system)
            nounButton.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5)
            nounButton.setTitle(noun, for: UIControlState())
            nounButton.addTarget(self, action: #selector(InputViewController.selectNoun(_:)), for: UIControlEvents.touchUpInside)
            nounStackView.addArrangedSubview(nounButton)
        }

        let verbs = getVerbs()
        for verb in verbs {
            let verbButton = UIButton(type: UIButtonType.system)
            verbButton.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 0.5)
            verbButton.setTitle(verb, for: UIControlState())
            verbButton.addTarget(self, action: #selector(InputViewController.selectVerb(_:)), for: UIControlEvents.touchUpInside)
            verbStackView.addArrangedSubview(verbButton)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeScrollView.contentSize = CGSize(width: timeStackView.frame.width, height: timeStackView.frame.height)
        nounScrollView.contentSize = CGSize(width: nounStackView.frame.width, height: nounStackView.frame.height)
        verbScrollView.contentSize = CGSize(width: verbStackView.frame.width, height: verbStackView.frame.height)
    }

    @IBOutlet weak var timeScrollView: UIScrollView!
    @IBOutlet weak var timeStackView: UIStackView!
    
    @IBAction func selectTime(_ sender: UIButton) {
        logEntry.time = sender.titleLabel!.text
        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = logEntry.description
    }

    @IBOutlet weak var nounScrollView: UIScrollView!
    @IBOutlet weak var nounStackView: UIStackView!
    
    @IBAction func selectNoun(_ sender: UIButton) {
        logEntry.noun = sender.titleLabel!.text
        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = logEntry.description
    }

    @IBOutlet weak var verbScrollView: UIScrollView!
    @IBOutlet weak var verbStackView: UIStackView!
    
    @IBAction func selectVerb(_ sender: UIButton) {
        logEntry.verb = sender.titleLabel!.text
        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = logEntry.description
    }
    
    @IBOutlet weak var logText: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!

    @IBAction func saveLog(_ sender: UIButton) {
        
        // TODO:  Implement Save...
        clearLog(sender)
    }

    @IBAction func clearLog(_ sender: UIButton) {

        logEntry.clear()
        logText.text = logEntry.description
        
        logText.textColor = UIColor.gray
        
        saveButton.isEnabled = false
        clearButton.isEnabled = false
    
    }
    
    
    private func enableSaveButton() {
        if (logEntry.validate()) {
            saveButton.isEnabled = true
        }
    }
    
    fileprivate func getVerbs() -> [String] {
        
        let verbs = ["Cycled","Watched Netflix","Played Video Games","Worked on Sownata"]
        return verbs
        
    }

    fileprivate func getTimes() -> [String] {
        
        let times = ["Today","Just Now","Custom"]
        return times
        
    }

    fileprivate func getNouns() -> [String] {
        
        let nouns = ["I"]
        return nouns
        
    }
    
}
