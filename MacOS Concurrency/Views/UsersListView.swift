//
//  UsersListView.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 31.03.22.
//

import SwiftUI

struct UsersListView: View {
    
    // Warning: Before shipment please remove forPreview argument
    
    @StateObject var vm = UserListViewModel(forPreview: false)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
                    }
                }
            }
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                await vm.fetchUsers()
            }
        }
        
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
