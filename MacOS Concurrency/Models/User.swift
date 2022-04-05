//
//  User.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 31.03.22.
//

import Foundation

// Source for this JSON: https://jsonplaceholder.typicode.com/users

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
