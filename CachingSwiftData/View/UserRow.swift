//
//  UserColumn.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI

struct UserRow: View {
    let user: UserEntity
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
                    .clipShape(shape)
            } placeholder: {
                shape.foregroundColor(.secondary)
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
            }.padding(.horizontal)
            Text(user.login)
                .font(.title3)
            Spacer()
        }.onTapGesture {
            navigationPath.append(.detail(user: user))
        }
    }
    
    private struct Constants {
        static let cornerRadius: Double = 10
        static let frameSize: Double = 120
    }
}

#Preview {
    @State var navigationPath = [NavigationPath]()
    return ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        VStack {
            UserRow(user: UserEntity.user, navigationPath: $navigationPath)
            UserRow(user: UserEntity.user, navigationPath: $navigationPath)
        }
        .padding()
        .frame(minWidth: 300, alignment: .leading)
    }
}
