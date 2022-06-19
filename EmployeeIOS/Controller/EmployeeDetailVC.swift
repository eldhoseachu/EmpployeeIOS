//
//  EmployeeDetailVC.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import UIKit

class EmployeeDetailVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var lblWebsite: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    // MARK: - Variables
    var employeeData: Employee?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.cornerRadius = 40
        
        configData()
        // Do any additional setup after loading the view.
    }
    
    func configData() {
        if let empData = employeeData {
            lblName.text = empData.name ?? ""
            lblUserName.text = empData.username ?? ""
            
            lblEmail.text = empData.email ?? ""
            lblWebsite.text = empData.website ?? "NA"
            lblCompany.text = "\(empData.company?.name ?? "") (\(empData.company?.catchPhrase ?? ""), \(empData.company?.bs ?? ""))"
            
            lblAddress.text = "\(empData.address?.street ?? ""), \(empData.address?.suite ?? ""), \(empData.address?.city ?? ""), \(empData.address?.zipcode ?? "")"
            
            if let url = URL(string: empData.profileImage ?? "") {
                ApiHandler.shared().downloadImage(from: url) { (imgData, urlRes, error) in
                    if let imgData = imgData {
                        DispatchQueue.main.async {
                            self.imgProfile.image = UIImage(data: imgData)
                        }
                    }
                    else {
                        self.imgProfile.image = UIImage(named: "profile")!
                    }
                }
            }
            else {
                imgProfile.image = UIImage(named: "profile")!
            }
        }
    }
}
