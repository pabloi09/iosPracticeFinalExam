//
//  DrawView.swift
//  Practice Second Exam
//
//  Created by Pablo Martín Redondo on 18/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

struct DrawView: View {
    @State var opacity : Double = 1
    @Binding var dibujoSeleccion : String
    var body: some View {
        VStack{
            RajoyRow(opacity: $opacity, seleccion: dibujoSeleccion)
            getFigure()
            RajoyRow(opacity: $opacity, seleccion: dibujoSeleccion)
            Slider(value: $opacity).padding()
        }
    }
    
    func getFigure() -> AnyView{
        return dibujoSeleccion == "estrella" ?
            AnyView(StarView(opacity: $opacity)):
            AnyView(PiramideView(opacity: $opacity))
        
    }
}

struct RajoyRow: View {
    @Binding var opacity : Double
    var seleccion: String
    var body: some View {
        let shape = FigureSelector(selector: seleccion)
        let image = Image("downloading")
        .resizable()
        .frame(width: 80, height: 80)
        .clipShape(shape)
        .shadow(radius: 3)
        return HStack{
            image
            image
            image
            image
        }.opacity(opacity)
        
        
    }
    
}

struct FigureSelector : Shape {
    var selector : String
    func path(in rect: CGRect) -> Path {
        
        if(selector == "estrella"){
            return Star(fAltura: 1).path(in: rect)
        }else{
            return Piramide(fAltura: nil).path(in: rect)
        }
        
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

struct Piramide: Shape {
    
    var fAltura: CGFloat?
    
    func path(in rect: CGRect) -> Path {
        
        let w = rect.size.width
        let h = rect.size.height
        
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: w/2, y: fAltura ?? 0))
        path.closeSubpath()
        
        return path
    }
}

struct StarView: View {
    
    @GestureState var scale: CGFloat = 1
    @Binding var opacity : Double
    
    var body: some View {
        GeometryReader { geometry in
            Star(fAltura: self.scale)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.green, .red, .blue, .yellow]),
                    startPoint: .top,
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
        .opacity(opacity)
        
        
    }
    
}

struct PiramideView: View {
    
    @State var y : CGFloat = 100
    @Binding var opacity : Double
    var body: some View {
        
        GeometryReader {geometry in
            Piramide(fAltura: self.y)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.green, .red, .blue, .yellow]),
                    startPoint: .top,
                    endPoint: .bottom))
                .overlay(Piramide(fAltura: self.y)
                    .stroke(Color.red, lineWidth: 3))
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            self.y = value.location.y
                    }
            )
        }
        .padding()
        .opacity(opacity)
        
    }
}





