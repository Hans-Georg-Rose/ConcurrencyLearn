//
//  PostsListView.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 01.04.22.
//

import SwiftUI

struct PostsListView: View {
    
    @StateObject var vm = PostsListViewModel(forPreview: false)
    var userId: Int?
    
    var body: some View {

        NavigationView {
            List {
                ForEach(vm.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.callout)
                            .foregroundColor(.secondary)
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
            .navigationTitle("Posts")
//            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .onAppear {
                vm.userId = userId
                vm.fetchPosts()
            }
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsListView(userId: 3)
        }
    }
}
