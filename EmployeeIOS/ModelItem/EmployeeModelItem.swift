//
//  EmployeeModelItem.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol EmployeeListingAPIDelegate: class {
    func didReceiveEmployeeList(error: Bool?, message: String?, employeeModel: [EmployeeModel])
}

class EmployeeModelItem {
    weak var delegate: EmployeeListingAPIDelegate?
    var employees: [Employee] = []
    
    func getEmployeeListAPI() {
        let url = "https://www.mocky.io/v2/5d565297300000680030a986"
        ApiHandler.shared().callAPI(callURl: url) { (resString, error, errorMsg) in
            
            if error == false {
                
                if let apiResponseModel = ApiHandler.shared().decode([EmployeeModel].self, from: resString ?? ""){
                    self.delegate?.didReceiveEmployeeList(error: false, message: nil, employeeModel: apiResponseModel)
                }else{
                    self.delegate?.didReceiveEmployeeList(error: true, message: nil, employeeModel: [])
                }
            }
        }
    }
    
    func saveToCoreData(employees: [EmployeeModel]) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for (_, employeeData) in employees.enumerated() {
            let emp = Employee(context: managedContext)
            emp.name = employeeData.name ?? ""
            emp.username = employeeData.username ?? ""
            emp.id = Int32(employeeData.id ?? 0)
            emp.profileImage = employeeData.profileImage ?? ""
            emp.email = employeeData.email ?? ""
            
            let add = Address(context: managedContext)
            add.city = employeeData.address?.city ?? ""
            add.street = employeeData.address?.street ?? ""
            add.suite = employeeData.address?.suite ?? ""
            add.zipcode = employeeData.address?.zipcode ?? ""
            
            let geoData = Geo(context: managedContext)
            geoData.lat = employeeData.address?.geo?.lat ?? ""
            geoData.lng = employeeData.address?.geo?.lng ?? ""
            
            add.geo = geoData
            
            emp.address = add
            
            let comp = Company(context: managedContext)
            comp.name = employeeData.company?.name ?? ""
            comp.catchPhrase = employeeData.company?.catchPhrase ?? ""
            comp.bs = employeeData.company?.bs ?? ""
            
            emp.company = comp
            if employeeExists(id: employeeData.id  ?? -1) {
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func fetchAllEmployees() -> [Employee] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do {
            employees = try (managedContext.fetch(fetchRequest) as? [Employee] ?? [])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return employees
    }
    
    func employeeExists(id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func searchEmployees(serachText: String) -> [Employee] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let predicate = NSPredicate(format: "%K CONTAINS[c] %@ OR %K CONTAINS[c] %@", "name", serachText, "email", serachText)
        
        fetchRequest.predicate = predicate
        
        do {
            employees = try (managedContext.fetch(fetchRequest) as? [Employee] ?? [])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return employees
    }
}
