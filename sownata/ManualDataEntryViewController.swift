//
//  ManualDataEntryViewController.swift
//  sownata
//
//  Created by Gary Joy on 24/04/2016.
//
//

import UIKit

class ManualDataEntryViewController: UIViewController {

    var logEntry = LogEntry()
    
    override func viewDidLoad() {
        
        logText.textColor = UIColor.gray

        logText.layer.cornerRadius = 5.0
        logText.clipsToBounds = true

        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.isNavigationBarHidden = true;
        
        
        let verbs = getVerbs()
        for verb in verbs {
            let verbButton = UIButton(type: UIButtonType.system)
            verbButton.setTitle(verb, for: UIControlState())
            verbButton.addTarget(self, action: #selector(ManualDataEntryViewController.selectVerb(_:)), for: UIControlEvents.touchUpInside)
            verbStackView.addArrangedSubview(verbButton)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        verbScrollView.contentSize = CGSize(width: verbStackView.frame.width, height: verbStackView.frame.height)
    }
    
    @IBOutlet weak var verbScrollView: UIScrollView!

    @IBOutlet weak var verbStackView: UIStackView!
    
    @IBOutlet weak var logText: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveLog(_ sender: UIButton) {
        clearLog(sender)
    }
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func clearLog(_ sender: UIButton) {

        logEntry.clear()
        logText.text = logEntry.description
        
        logText.textColor = UIColor.gray
        
        saveButton.isEnabled = false
        clearButton.isEnabled = false
    
    }
    
    @IBAction func selectVerb(_ sender: UIButton) {
        
        saveButton.isEnabled = true
        clearButton.isEnabled = true
        
        logText.textColor = UIColor.black
        logEntry.verb = sender.titleLabel!.text
        
        logText.text = logEntry.description
    }
    
    fileprivate func getVerbs() -> [String] {
        
        // List should be ordered with the most likely to be selected first...
        let verbs = ["Ran","Swam","Cycled","Slept","Waited","Worked","Wacthed TV","Weighed","Induldged"]
        return verbs
    
    }
    
    
}
