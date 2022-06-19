//
//  EmployeeListVC.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import UIKit
import CoreData

class EmployeeListVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var listSearchBar: UISearchBar!
    @IBOutlet weak var tblEmployee: UITableView!
    
    // MARK: - Variables
    let employeeModelItem = EmployeeModelItem()
    var employees = [Employee]()
    var employeeData: Employee?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let empData = employeeModelItem.fetchAllEmployees()
        
        if empData.count > 0 {
            employees = empData
        }
        else {
            employeeModelItem.getEmployeeListAPI()
        }
        
        employeeModelItem.delegate = self
        
        listSearchBar.delegate = self
        
        configTableview()
        // Do any additional setup after loading the view.
    }
    
    func configTableview() {
        tblEmployee.register(UINib(nibName: TableCellIdentifiers.kEmployeeListCell, bundle: nil), forCellReuseIdentifier: TableCellIdentifiers.kEmployeeListCell)
        tblEmployee.delegate = self
        tblEmployee.dataSource = self
        tblEmployee.tableFooterView = UIView()
        
        tblEmployee.estimatedRowHeight = 1000
        tblEmployee.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail" {
            if let nextViewController = segue.destination as? EmployeeDetailVC {
                nextViewController.employeeData = employeeData
            }
        }
    }
}

// MARK: - EmployeeListingAPIDelegate
extension EmployeeListVC: EmployeeListingAPIDelegate {
    func didReceiveEmployeeList(error: Bool?, message: String?, employeeModel: [EmployeeModel]) {
        
        employeeModelItem.saveToCoreData(employees: employeeModel)
        
        let empData = employeeModelItem.fetchAllEmployees()
        if empData.count > 0 {
            employees = empData
            tblEmployee.reloadData()
        }
    }
}

// MARK: - Tableview
extension EmployeeListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.kEmployeeListCell) as? EmployeeListCell {
            cell.selectionStyle = .none
            
            let employee = employees[indexPath.row]
            
            cell.configCell(employee: employee)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeData = employees[indexPath.row]
        
        self.performSegue(withIdentifier: "ListToDetail", sender: self)
    }
}

// MARK: - Search Bar Delegate
extension EmployeeListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        let empData = employeeModelItem.searchEmployees(serachText: searchText)
        
        if empData.count > 0 {
            employees = empData
            
            self.tblEmployee.reloadData()
        }
        else {
            employees = []
            self.tblEmployee.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        
        let empData = employeeModelItem.fetchAllEmployees()
        
        if empData.count > 0 {
            employees = empData
            self.tblEmployee.reloadData()
        }        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
