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
    
    var names: Results<ExampleData>? //ExampleData là class chứa object tạo lúc đầu nha
    let real = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPeople()
    }

    @IBAction func addPeopleTapped(_ sender: Any) {
        
        let newName = ExampleData()
        
        newName.name = textField.text!
        
        do {
            try real.write {
                real.add(newName)
            }
            loadPeople()
        } catch {
            print("Error add data")
        }
        
        textField.text = ""
    }
    
    func loadPeople() {
        names = real.objects(ExampleData.self)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names?[indexPath.row].name ?? "No name added yet."
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var updateTextField = UITextField()
        let alert = UIAlertController(title: "Update People", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Name You Want To Update"
            updateTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Update People", style: .default) { (action) in
            if let name = self.names?[indexPath.row]
            {
                do {
                    try self.real.write {
                    name.name = updateTextField.text!
                    self.loadPeople()
                    }
                } catch {
                    print("Error")
                }
            }
        }
        alert.addAction(action)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
}
