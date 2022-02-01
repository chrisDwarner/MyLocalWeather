//
//  AddPlacesView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import GooglePlaces
import RealmSwift
import SwiftUI
import Combine

/// View to host the Google Places view controller
struct AddPlacesView: View {
    @ObservedRealmObject var group: Group

    var body: some View {
        VStack {
            Text("Add a New City")
            PlacesViewController(group: group)
        }
    }
}

struct PlacesViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = GMSAutocompleteViewController
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedRealmObject var group: Group
    var controller = UIViewControllerType()
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        uiViewController.presentedViewController
    }
    
    func makeCoordinator() -> Coordinator {
        let controller = Coordinator(self, group: group)
        return controller
    }

    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        @ObservedRealmObject var group: Group
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            guard let cityName = place.name  else { return }
            let coord = place.coordinate
            let city = City(name: cityName, coord: coord)

            do {
                let realm = try Realm()
                
                let groups = realm.objects(Group.self)
                
                if !groups.isEmpty {
                    realm.beginWrite()
                    groups.forEach { group in
                        group.cities.append(city)
                        realm.add(group, update: .modified)
                    }
                    try realm.commitWrite()
                }
            }
            catch {
                print( error )
            }
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("failed with error: \(error.localizedDescription)")
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            print("canceled")
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
        let parent: PlacesViewController
        
        init(_ parent: PlacesViewController, group: Group) {
            self.parent = parent
            self.group = group
        }
    }
}

#if DEBUG
struct AddPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlacesView(group: Group())
    }
}
#endif
