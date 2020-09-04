//
//  TodoListViewController.swift
//  Lista de Tarefas
//
//  Created by Wanderson Hipolito on 03/09/20.
//  Copyright © 2020 Wanderson Hipolito. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Supermercado", "Farmacia", "Casa"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        
    }
    
    
    //MARK: - TableView Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
      }
      
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
      }
      
    
    //MARK: - TableView DElegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Bar Button Item
    @IBAction func addItemPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertAction = UIAlertController(title: "Adicionar Itens", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // onde usuario vai inserir o item
            self.itemArray.append(textField.text!)
            
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertAction.addTextField { (alertTExtField) in
            alertTExtField.placeholder = "Adicionar Item"
            textField = alertTExtField
        }
        
        
        alertAction.addAction(okAction)
        alertAction.addAction(cancelAction)
        
        present(alertAction, animated: true, completion: nil)
        
        
    }
    
}
