//
//  ViewController.swift
//  Realm-Demo
//
//  Created by Huy on 8/4/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var names: Results<ExampleData>! // ExampleObject is class in SampleData.swift
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        print(realm.configuration.fileURL!.deletingLastPathComponent().path)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPeople()
    }
    
    // MARK: Get
    func loadPeople() {
        names = realm.objects(ExampleData.self)
        tableView.reloadData()
    }
    
    // MARK: Post
    @IBAction func addPeopleTapped(_ sender: Any) {
        
        if textField.text != "" {
            let object = ExampleData()
            object.name = textField.text!
            
            try! realm.write {
                realm.add(object)
                loadPeople()
                textField.text = ""
            }
        }
    }

    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row].name
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    // MARK: Put
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var updateTextField = UITextField()
        let alert = UIAlertController(title: "Update people", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter name you want to update"
            updateTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Update people", style: .default) { (action) in
            if let name = self.names?[indexPath.row] {
                try! self.realm.write {
                    name.name = updateTextField.text!
                    self.loadPeople()
                }
            }
        }
        alert.addAction(action)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                self.realm.delete(names[indexPath.row])
                self.loadPeople()
            }
        }
    }
}
