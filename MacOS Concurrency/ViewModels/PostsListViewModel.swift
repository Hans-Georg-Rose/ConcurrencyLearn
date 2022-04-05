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
    
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            apiService.getJSON { (result: Result<[Post], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer to sort out this mess!"
                    }
                    print(error) // to be improved later
                }
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
