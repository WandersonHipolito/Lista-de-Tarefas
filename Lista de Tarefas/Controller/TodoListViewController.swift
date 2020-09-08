//
//  TodoListViewController.swift
//  Lista de Tarefas
//
//  Created by Wanderson Hipolito on 03/09/20.
//  Copyright © 2020 Wanderson Hipolito. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        // Do any additional setup after loading the view.

        loadItens()
        self.tableView.delegate = self
        
    }
    
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //using tenory operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        //        if itemArray[indexPath.row].done == true{
        //            cell.accessoryType = .checkmark
        //
        //        } else {
        //            cell.accessoryType = .none
        //
        //        }
        return cell
    }
    
    
    //MARK: - TableView DElegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Bar Button Item
    @IBAction func addItemPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertAction = UIAlertController(title: "Adicionar Itens", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // onde usuario vai inserir o item
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
            self.saveItems()
            self.tableView.reloadData()
            
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
    
    //MARK: - Salvando os itens
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
            
        }catch{
            print("Erro no ecoding do itemArray: \(error)")
            
        }
    }
    
    //MARK: - Metodo para carregar os itens
    
    func loadItens() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                print("Erro ao carregar dados: \(error.localizedDescription)")
            }
        }
    }
    
}
