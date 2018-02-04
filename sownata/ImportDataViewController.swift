//
//  ImportDataViewController.swift
//  sownata
//
//  Created by Gary Joy on 24/04/2016.
//
//

import UIKit

import CoreData

class ImportDataViewController: UITableViewController {

//    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
//
//    func initializeFetchedResultsController() {
//        let request: NSFetchRequest<Event> = Event.fetchRequest()
//        let lastNameSort = NSSortDescriptor(key: "verb.id", ascending: true)
//        request.sortDescriptors = [lastNameSort]
//
//        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
//        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
//
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            fatalError("Failed to initialize FetchedResultsController: \(error)")
//        }
//    }
    
//    var fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
//                  "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
//                  "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
//                  "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
//                  "Pear", "Pineapple", "Raspberry", "Strawberry"]
    
    var eventsModel = EventsModel(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)

    var refresher: UIRefreshControl!
        
    override func viewDidLoad() {
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(reloadEvents), for: .valueChanged)
    }
    
    @objc func reloadEvents() {
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowCount = eventsModel.events!.count
        print("Rows: \(rowCount)")
        return rowCount  // fruits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = eventsModel.events![indexPath.row].description // fruits[indexPath.row]
        
        return cell
    }
   
}
