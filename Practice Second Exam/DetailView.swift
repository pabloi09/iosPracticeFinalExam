//
//  DetailView.swift
//  Practice Second Exam
//
//  Created by Pablo Martín Redondo on 16/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var item : Item
    @ObservedObject var imageDownloader : ImageDownloader
    @ObservedObject var memory : Memory
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Text(self.item.title)
                    .font(.largeTitle)
                    .frame(minWidth: 0.0, maxWidth: .infinity, alignment: .leading)
                    .padding()
                Image(uiImage: self.imageDownloader.image(url: self.item.url))
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.width)
                Spacer()
            }
            .navigationBarItems(trailing:
                HStack{
                    Button(action: {
                        self.memory.change(item: self.item)
                    }, label: {
                        Image(systemName: self.memory.contains(item: self.item) ?
                            "icloud.and.arrow.down.fill" : "icloud.and.arrow.down")
                        .foregroundColor(Color.blue)
                    })
                }
            )
            .navigationBarTitle("Details of item")
            
        }
    }
    
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ModelItems()
        model.download()
        return DetailView(item: model.items[0],imageDownloader: ImageDownloader(), memory: Memory())
    }
}
