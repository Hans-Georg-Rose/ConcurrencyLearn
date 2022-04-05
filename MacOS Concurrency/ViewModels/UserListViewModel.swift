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
    
    @MainActor
    
    // Make usage of the APIService function to get JSON data
    
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            users = try await apiService.getJSON()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer to sort out this mess!"
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
