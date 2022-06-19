//
//  EmployeeModel.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import Foundation

// MARK: - Employee
struct EmployeeModel: Codable {
    let id: Int?
    let name, username, email: String?
    let profileImage: String?
    let address: AddressModel?
    let phone, website: String?
    let company: CompanyModel?

    enum CodingKeys: String, CodingKey {
        case id, name, username, email
        case profileImage = "profile_image"
        case address, phone, website, company
    }
}

// MARK: - Address
struct AddressModel: Codable {
    let street, suite, city, zipcode: String?
    let geo: GeoModel?
}

// MARK: - Geo
struct GeoModel: Codable {
    let lat, lng: String?
}

// MARK: - Company
struct CompanyModel: Codable {
    let name, catchPhrase, bs: String?
}
