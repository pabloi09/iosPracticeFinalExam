//
//  ContentView.swift
//  Practice Second Exam
//
//  Created by Pablo Martín Redondo on 16/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model : ModelItems
    @EnvironmentObject var imageDownloader : ImageDownloader
    @EnvironmentObject var memory : Memory
    @State var scaleTotal: CGFloat = 1
    @State var scale: CGFloat = 1
    @State var angleTotal: Angle = .zero
    @State var angle: Angle = .zero
    @State var title : String = "Model and gestures"
    var body: some View {
        NavigationView{
            TabView(selection: $title){
                List{
                    ForEach(model.items) { item in
                        NavigationLink(destination: DetailView(item: item, imageDownloader: self.imageDownloader, memory: self.memory)){
                            RowView(item: item,
                                    imageDownloader: self.imageDownloader,
                                    scaleTotal: self.$scaleTotal,
                                    scale: self.$scaleTotal,
                                    angleTotal: self.$angleTotal,
                                    angle: self.$angle)
                        }
                        .frame(height: 160 * self.scaleTotal * self.scale)
                    }
                }
                .tabItem{
                    Text("Downloads")
                    Image(systemName: "icloud")
                }.tag("Model and gestures")
                List {
                    ForEach(memory.items){  item in
                        NavigationLink(destination: DetailView(item: item, imageDownloader: self.imageDownloader, memory: self.memory)){
                            RowView(item: item,
                                    imageDownloader: self.imageDownloader,
                                    scaleTotal: self.$scaleTotal,
                                    scale: self.$scaleTotal,
                                    angleTotal: self.$angleTotal,
                                    angle: self.$angle)
                        }
                        .frame(height: 160 * self.scaleTotal * self.scale)
                        
                    }
                }
                .tabItem{
                    Text("Storage")
                    Image(systemName: "icloud.and.arrow.down")
                }.tag("Persistence")
            }
                
            .navigationBarTitle(title)
        }
        .modifier(Gestures(scaleTotal: $scaleTotal, scale: $scale, angleTotal: $angleTotal, angle: $angle))
        
    }
}
struct RowView: View {
    var item : Item
    @ObservedObject var imageDownloader : ImageDownloader
    @Binding var scaleTotal: CGFloat
    @Binding var scale: CGFloat
    @Binding var angleTotal: Angle
    @Binding var angle: Angle
    
    var body: some View {
        HStack{
            Image(uiImage: self.imageDownloader.image(url: item.thumbnailUrl))
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .scaledToFit()
                .scaleEffect(self.scaleTotal * self.scale)
                .rotationEffect(self.angle)
            
            Text(item.title).scaleEffect(self.scaleTotal * self.scale)
        }
    }
    
    
}



struct Gestures : ViewModifier {
    
    @Binding var scaleTotal: CGFloat
    @Binding var scale: CGFloat
    @Binding var angleTotal: Angle
    @Binding var angle: Angle
    
    func body(content : Content) -> some View {
        content
            .gesture(
                MagnificationGesture(minimumScaleDelta: 0.5)
                    .onChanged { scale in
                        self.scale = scale
                }
                .onEnded { _ in
                    if(self.scaleTotal * self.scale > 1.5){
                        self.scaleTotal = 1.5
                    }else if(self.scaleTotal * self.scale < 0.5){
                        self.scaleTotal = 0.5
                    } else {
                        self.scaleTotal = 1
                    }
                    self.scale = 1
                }
                .simultaneously(with:
                    
                    RotationGesture(minimumAngleDelta: Angle(degrees: 1))
                        .onChanged { angle in
                            self.angle = angle
                    }
                    .onEnded { _ in
                        self.angleTotal += self.angle
                        self.angle = .zero
                    }
                )
                
        )
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
