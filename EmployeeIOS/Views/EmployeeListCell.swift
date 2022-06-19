//
//  EmployeeListCell.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import UIKit

class EmployeeListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgProfile.layer.cornerRadius = 35
    }
    
    func configCell(employee: Employee) {
        lblName.text = employee.name ?? ""
        lblCompanyName.text = employee.company?.name
        
        if let url = URL(string: employee.profileImage ?? "") {
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
