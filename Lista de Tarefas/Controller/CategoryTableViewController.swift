//
//  CategoryTableViewController.swift
//  Lista de Tarefas
//
//  Created by Wanderson Hipolito on 13/09/20.
//  Copyright © 2020 Wanderson Hipolito. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //variables
    var categoryArray = [Category]()
    let request : NSFetchRequest<Category> = Category.fetchRequest()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        loadCategory(with: request)
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CategoryCell <- resuable cell name
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Add New Categories
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()// fazendo uma var para a função para captar o texto dentro do alert|Control
        let alertControl = UIAlertController(title: "Add Category", message: "Add a category to your list", preferredStyle: .alert)
        let alertADD = UIAlertAction(title: "Add", style: .default) { (action) in
            //onde vai ser inserido os itens
            print("add new category")
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            self.tableView.reloadData()
            
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //adicionando um textField a janela de alerta
        alertControl.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alertControl.addAction(alertADD)
        alertControl.addAction(alertCancel)
        
        present(alertControl, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //
        //
        //
        //        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "gotoItem", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //levar os item pra outra tableview
        let destinationViewController = segue.destination as! TodoListViewController
        //vai mandar os dados para uma celula da table do todolist
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    // MARK: - Data Manipulation Methods
    func saveCategory() {
        
        do {
            try contex.save()
            
        } catch  {
            print("Erro in context function Category: \(error.localizedDescription)")
            
        }
    }
    
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
          categoryArray = try contex.fetch(request)
            
        } catch  {
            print("Error in request function category: \(error.localizedDescription)")
            
        }
    }
    
    
}
