//
//  MapaView.swift
//  Practice Second Exam
//
//  Created by Pablo Martín Redondo on 18/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI
import MapKit
struct MapaView: View {
    
    @State var mapType : MKMapType = MKMapType.standard
    @State var mapPlace : Site = .coupertino
    var body: some View {
        ZStack{
            MapaComponent(center: mapPlace.coordinate(), mapType: mapType)
            VStack{
                MapPlaceSelector(mapPlace: $mapPlace)
                Spacer()
                MapTypeSelector(mapType: $mapType)
            }
        }
    }
}

struct MapaComponent : UIViewRepresentable {
    
    var center: CLLocationCoordinate2D
    var mapType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView()
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = mapType
    }
}

struct MapTypeSelector: View {
    
    @Binding var mapType: MKMapType
    
    var body: some View {
        Picker(selection: $mapType,
               label: Text("Tipo de mapa")) {
                Text("Estándar").tag(MKMapType.standard)
                Text("Satélite").tag(MKMapType.satellite)
                Text("Híbrido").tag(MKMapType.hybrid)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

struct MapPlaceSelector: View {
    
    @Binding var mapPlace: Site
    
    var body: some View {
        Picker(selection: $mapPlace,
               label: Text("Tipo de mapa")) {
                items
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    var items: some View {
        ForEach([Site.coupertino, .hBeach, .googleZ], id: \.self) { s in
            Text(s.rawValue).tag(s)
        }
        .font(.headline)
        .padding()
    }
}


struct MapaView_Previews: PreviewProvider {
    static var previews: some View {
        MapaView()
    }
}
