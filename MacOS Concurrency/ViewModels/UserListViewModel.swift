//
//  UserListViewModel.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 01.04.22.
//

import Foundation

class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    // Make usage of the APIService function to get JSON data
    
    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a slow network to make prograssview visible
            apiService.getJSON { (result: Result<[User], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
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

extension UserListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
