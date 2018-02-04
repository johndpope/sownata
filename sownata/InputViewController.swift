//
//  InputViewController.swift
//  sownata
//
//  Created by Gary Joy on 24/04/2016.
//
//

import UIKit

class InputViewController: UIViewController {

    var newEvent = NewEvent() // This is our Model
    
    var eventsModel = EventsModel(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
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

        let pronouns = eventsModel.pronouns!
        for pronoun in pronouns {
            let nounButton = UIButton(type: UIButtonType.system)
            nounButton.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5)
            nounButton.setTitle(pronoun.name, for: UIControlState())
            nounButton.addTarget(self, action: #selector(InputViewController.selectNoun(_:)), for: UIControlEvents.touchUpInside)
            nounStackView.addArrangedSubview(nounButton)
        }

        let verbs = eventsModel.verbs!
        for verb in verbs {
            let verbButton = UIButton(type: UIButtonType.system)
            verbButton.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 0.5)
            verbButton.setTitle(verb.name, for: UIControlState())
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
        newEvent.time = sender.titleLabel!.text
        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = newEvent.description
    }

    @IBOutlet weak var nounScrollView: UIScrollView!
    @IBOutlet weak var nounStackView: UIStackView!
    
    @IBAction func selectNoun(_ sender: UIButton) {
        let eventNoun = eventsModel.findNoun(id: sender.titleLabel!.text!)
        newEvent.noun = eventNoun!
        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = newEvent.description
    }

    @IBOutlet weak var verbScrollView: UIScrollView!
    @IBOutlet weak var verbStackView: UIStackView!
    
    @IBAction func selectVerb(_ sender: UIButton) {
        let eventVerb = eventsModel.findVerb(id: sender.titleLabel!.text!)
        newEvent.verb = eventVerb!

        enableSaveButton()
        clearButton.isEnabled = true
        logText.text = newEvent.description
    }
    
    @IBOutlet weak var logText: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!

    @IBAction func saveLog(_ sender: UIButton) {
        
        _ = eventsModel.createEvent(when: Date(), primaryNoun: newEvent.noun!, verb: newEvent.verb!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        clearLog(sender)

    }

    @IBAction func clearLog(_ sender: UIButton) {

        newEvent.clear()
        logText.text = newEvent.description
        
        logText.textColor = UIColor.gray
        
        saveButton.isEnabled = false
        clearButton.isEnabled = false
    
    }
    
    
    private func enableSaveButton() {
        if (newEvent.validate()) {
            saveButton.isEnabled = true
        }
    }
    
    fileprivate func getTimes() -> [String] {
        
        let times = ["Now"]
        return times
        
    }
    
}
