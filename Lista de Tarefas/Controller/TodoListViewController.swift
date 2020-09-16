//
//  TodoListViewController.swift
//  Lista de Tarefas
//
//  Created by Wanderson Hipolito on 03/09/20.
//  Copyright © 2020 Wanderson Hipolito. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    var selectedCategory: Category?{
        didSet{
            loadItens()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist"))
        self.tableView.delegate = self
        //self.loadItens(with: request)
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
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        do{
            try context.save()
            
        }catch{
            print("Error to try save contex: \(error)")
            
        }
    }
    
    //MARK: - Metodo para carregar os itens
    
    func loadItens(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        }else {
            request.predicate = categoryPredicate
            
        }
        
        
        do {
            itemArray = try context.fetch(request)
            
        } catch  {
            print("Error in fetching context: \(error)")
            
        }
    }
    
}

//MARK: - UISearchbarDelegate
extension TodoListViewController: UISearchBarDelegate{
    
    //função procura pelas palavras que estao na lista
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        //fazer consulta no bd
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.loadItens(with: request, predicate: predicate)
        self.tableView.reloadData()
        
    }
    // função faz voltar a lista original
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItens()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
