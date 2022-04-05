//
//  PostListViewModel.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 01.04.22.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?

    
    var userId: Int?
    
    // Make usage of the APIService function to get JSON data
    
    @MainActor // Dispatch back to the main queue
    
    func fetchPosts() async {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            defer {
                isLoading = false
            }
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nPlease contact the developer to sort out this mess!"
            }
        }
    }
}

extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = Post.mockSingleUsersPostsArray
        }
    }
}
