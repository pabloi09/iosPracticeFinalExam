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
    @State var title : String = "Model and gestures"
    @State var dibujoSeleccion : String = "estrella"
    var body: some View {
        NavigationView{
            TabView(selection: $title){
                ListView(items: model.items,
                         imageDownloader: self.imageDownloader,
                         memory: self.memory)
                    .tabItem{
                        Text("Downloads")
                        Image(systemName: "icloud")
                }.tag("Model and gestures")
                ListView(items: memory.items,
                         imageDownloader: self.imageDownloader,
                         memory: self.memory)
                    .tabItem{
                        Text("Storage")
                        Image(systemName: "icloud.and.arrow.down")
                }.tag("Persistence")
                DrawView(dibujoSeleccion: $dibujoSeleccion)
                    .tabItem {
                        Text("Draw")
                        Image(systemName: "pencil")
                        
                }.tag("Draw")
                MapaView()
                    .tabItem{
                        Text("Map")
                        Image(systemName: "map")
                }.tag("Component of UIKit")
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: getPicker())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func getPicker() -> AnyView{
        return title == "Draw" ?
            AnyView(PickerDraw(seleccion: $dibujoSeleccion)):
            AnyView(EmptyView())
        
    }
}

struct ListView: View {
    var items : [Item]
    @ObservedObject var imageDownloader : ImageDownloader
    @ObservedObject var memory : Memory
    @State var scaleTotal: CGFloat = 1
    @State var scale: CGFloat = 1
    @State var angleTotal: Angle = .zero
    @State var angle: Angle = .zero
    
    var body: some View {
        List{
            ForEach(items) { item in
                NavigationLink(destination: DetailView(item: item, imageDownloader: self.imageDownloader, memory: self.memory)){
                    HStack{
                        Image(uiImage: self.imageDownloader.image(url: item.thumbnailUrl))
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.7, y: 0.7)),lineWidth: 5))
                            .scaledToFit()
                            .scaleEffect(self.scaleTotal * self.scale)
                            .rotationEffect(self.angle)
                        
                        Text(item.title).scaleEffect(self.scaleTotal * self.scale)
                    }
                }
                .frame(height: 160 * self.scaleTotal * self.scale)
            }
            
        }
        .modifier(Gestures(scaleTotal: $scaleTotal, scale: $scale, angleTotal: $angleTotal, angle: $angle))
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

struct PickerDraw: View {
    @Binding var seleccion : String
    var body: some View {
        Picker(selection: $seleccion,
               label: Text("Seleccionar figura")) {
                Text("⭐️").tag("estrella")
                Text("🔺").tag("triangulo")
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
