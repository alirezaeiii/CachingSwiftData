//
//  DetailView.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

import SwiftUI

struct DetailView: View {
    let user: UserEntity
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(height: Constants.frameHeight)
            }
            Spacer()
        }
        .navigationTitle(user.login)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct Constants {
        static let frameHeight: Double = 400
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        DetailView(user: UserEntity.user)
    }
    
}
