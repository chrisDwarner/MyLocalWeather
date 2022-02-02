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

/// PlacesViewController is a UIViewControllerRepresentable that  lauches
///  the Google places  GMSAutocompleteViewController
/// this view controller is a UIKit based control so we need to wrap it
/// in the UIViewControllerRepresentable for display in SwiftUI
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

    // the coordinator class holds the delegate implementation of the hosted UIViewController.
    // this is how we communicate between SwiftUI and UIKit hosted viewControllers
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        @ObservedRealmObject var group: Group
        let parent: PlacesViewController  // we hold a reference to the parent View so we can dismiss it
        

        // user selected a city
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            guard let cityName = place.name  else { return }
            let coord = place.coordinate
            let city = City(name: cityName, coord: coord)

            do {
                let realm = try Realm()
                
                let groups = realm.objects(Group.self)
                
                // can't add a city with no groups.  This should never happen
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
