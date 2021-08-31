//
//  TableViewController.swift
//  DemoCoreDataOne
//
//  Created by Danya on 31.08.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDiscription = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDiscription]
        
        do {
           tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let alertControler = UIAlertController(title: "Новая задача", message: "Пожалуйста, запишите новую задучу", preferredStyle: .alert)
        let saveControler = UIAlertAction(title: "Сохранить", style: .default) { action in
            let textField = alertControler.textFields?.first
            if let newTaskTitle = textField?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }
        
        alertControler.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        alertControler.addAction(saveControler)
        alertControler.addAction(cancelAction)
        
        present(alertControler, animated: true, completion: nil)
        
    }
    
    private func saveTask(withTitle title: String) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Можно кстати чуть сократить код, вижу две одиноковые строчки, делаю вот так
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }

}
