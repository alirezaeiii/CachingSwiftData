//
//  UserColumn.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI

struct UserColumn: View {
    let user: UserEntity
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        VStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
                    .clipShape(shape)
            } placeholder: {
                shape.foregroundColor(.secondary)
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
            }
            Text(user.login)
                .font(.title3)
        }.padding()
            .onTapGesture {
                navigationPath.append(.detail(user: user))
            }
    }
    
    private struct Constants {
        static let cornerRadius: Double = 10
        static let frameSize: Double = 160
    }
}

#Preview {
    @State var navigationPath = [NavigationPath]()
    return ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
            VStack {
                UserColumn(user: UserEntity.user, navigationPath: $navigationPath)
                UserColumn(user: UserEntity.user, navigationPath: $navigationPath)
            }
            .padding()
            .frame(minWidth: 300, alignment: .leading)
        }
}
