//
//  FilterView.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/9/20.
//

import SwiftUI
import Combine

struct FilterView: View {
    @ObservedObject var dataManager: DataManager
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Timeframe")) {
                    ForEach(TimeframeFilter.allCases, id: \.self) { timeframe in
                        SelectionCell(value: timeframe, selectedValue: $dataManager.timeframeFilter)
                    }
                }
                Section(header: Text("Magnitude")) {
                    ForEach(MagnitudeFilter.allCases, id: \.self) { magnitude in
                        SelectionCell(value: magnitude, selectedValue: $dataManager.magnitudeFilter)
                    }
                }
                Section(header: Text("Location")) {
                    ForEach(LocationFilter.allCases, id: \.self) { location in
                        SelectionCell(value: location, selectedValue: $dataManager.locationFilter)
                    }
                }
            }.alert(isPresented: $dataManager.showLocationAlert) {
                Alert(title: Text("You must enable Location access in settings first"), message: nil, dismissButton: .default(Text("OK")))
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Filter")
            .navigationBarItems(trailing:
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            )
        }
    }
}

private struct SelectionCell<T: TitleRepresentable>: View {
    let value: T
    @Binding var selectedValue: T
    
    var body: some View {
        HStack {
            Text(value.title)
				.font(.bodyStyle)
            Spacer()
            if selectedValue == value {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        // This is a hack so that the whole cell is a tap target and not just the text
        .background(Color(.secondarySystemGroupedBackground))
        .onTapGesture {
            selectedValue = value
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text(value.title))
        .accessibility(value: selectedValue == value ? Text("selected") : Text(""))
        .accessibility(hint: selectedValue == value ? Text("") : Text("Double tap to select"))
    }
}

// MARK: - Preview

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(dataManager: DataManager())
    }
}
