//
//  Post.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 31.03.22.
//

import Foundation

// Source for this JSON: https://jsonplaceholder.typicode.com/posts
// Single Users posts only: https://jsonplaceholder.typicode.com/posts/1/comments

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
