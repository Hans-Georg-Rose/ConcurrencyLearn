//
//  MockData.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 01.04.22.
//

import Foundation

extension User {
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "users.json")
    }
    static var singleUser: User {
        self.mockUsers[0]
    }
}

extension Post {
    static var mockPosts: [Post] {
        Bundle.main.decode([Post].self, from: "posts.json")
    }
    static var singlePost: Post {
        self.mockPosts[0]
    }
    
    static var mockSingleUsersPostsArray: [Post] {
        Self.mockPosts.filter { $0.userId == 1 }
    }
}

