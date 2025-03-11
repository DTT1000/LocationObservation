//
//  MapView.swift
//  LocationObservation
//
//  Created by Dominic Thompson on 3/10/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.dismiss) private var dismiss

    var region: MKCoordinateRegion

    var cameraPosition: MapCameraPosition {
        MapCameraPosition.region(region)
    }

    var body: some View {
        ZStack {
            Map(position: .constant(cameraPosition), interactionModes: []) {
                UserAnnotation()
            }

            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(.ultraThickMaterial)

                    Image(systemName: "xmark")
                        .foregroundStyle(.red)
                }
                .frame(width: 32, height: 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
        }
    }
}
