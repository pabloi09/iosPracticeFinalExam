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
                VStack{
                    RajoyStarRow()
                    StarView()
                    RajoyStarRow()
                }
                .tabItem {
                    Text("Draw")
                    Image(systemName: "pencil")
                    
                }.tag("Draw")
            }
            .navigationBarTitle(title)
        }
        
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
struct Star: Shape {
    
    var fAltura: CGFloat
    
    //Intento de estrella not that bad
    func path(in rect: CGRect) -> Path {
        
        let w = rect.size.width
        let h = rect.size.height
        
        var path = Path()
        
        path.move(to: CGPoint(x: w/2, y: 0))
        path.addLine(to: CGPoint(x: w/2 + w/7, y: h/4))
        path.addLine(to: CGPoint(x: w, y: h/4))
        path.addLine(to: CGPoint(x: w/2 + 2*w/7, y: h/2))
        path.addLine(to: CGPoint(x: w/2 + 3*w/7, y: h))
        path.addLine(to: CGPoint(x: w/2, y: 3*h/4))
        path.addLine(to: CGPoint(x: w/2 - 3*w/7, y: h))
        path.addLine(to: CGPoint(x: w/2 - 2*w/7, y: h/2))
        path.addLine(to: CGPoint(x: 0, y: h/4))
        path.addLine(to: CGPoint(x: w/2 - w/7, y: h/4))
        path.closeSubpath()
        
        return path
    }
}

struct StarView: View {
    
    @GestureState var scale: CGFloat = 1
    
    var body: some View {
        GeometryReader { geometry in
            Star(fAltura: self.scale)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.green, .red, .blue, .yellow]),
                    startPoint: UnitPoint(x: 0.5, y: 1-self.scale),
                    endPoint: .bottom))
                .overlay(Star(fAltura: self.scale)
                    .stroke(Color.black, lineWidth: 3))
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
                .scaleEffect(self.scale)
                .gesture(
                    MagnificationGesture(minimumScaleDelta: 0.01)
                        .updating(self.$scale) { (value, state, transaction) in
                            state = value
                })
        }
        .padding()
        
        
    }
    
}

struct RajoyStarRow: View {
    
    
    var body: some View {
        HStack{
            Image("downloading")
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Star(fAltura: 1))
            
            Image("downloading")
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Star(fAltura: 1))
            
            Image("downloading")
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Star(fAltura: 1))
            
            Image("downloading")
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Star(fAltura: 1))
            Image("downloading")
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Star(fAltura: 1))
        }
        
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
