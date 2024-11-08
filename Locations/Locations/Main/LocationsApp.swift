//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

let navigator = WikipediaLocationNavigator(openUrl: { UIApplication.shared.open($0) })
let session = URLSession(configuration: .ephemeral)
let httpClient = UrlSessionHttpClient(session: session)
let locationProvider = RemoteLocationsProvider(httpClient: httpClient)

@main
struct LocationsApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsView(
                model: LocationsViewModel(
                    locationsProvider: locationProvider,
                    onLocationSelection: navigator.showLocationOnWikipedia
                )
            )
        }
    }
}
