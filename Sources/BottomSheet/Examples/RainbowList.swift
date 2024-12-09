//
//  RainbowList.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//

import SwiftUI

struct RainbowList: View {

    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]

    var body: some View {
        VStack {
            ForEach((0..<colors.count * 10), id: \.self) { index in
                let color = colors[index % colors.count]
                Text(color.description)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(color)
            }
        }
    }

}

#Preview {
    RainbowList()
        .onScrollGeometryChange(for: ScrollGeometry.self) { geometry in
            geometry
        } action: { _, geometry in
            print(geometry)
        }
}
