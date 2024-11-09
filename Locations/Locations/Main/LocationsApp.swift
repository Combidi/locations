//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

let session = URLSession(configuration: .ephemeral)
let httpClient = UrlSessionHttpClient(session: session)
let locationProvider = RemoteLocationsProvider(httpClient: httpClient)

@main
struct LocationsApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsView(
                model: LocationsViewModelAssembler.make(
                    locationsProvider: locationProvider,
                    openUrl: { UIApplication.shared.open($0) }
                )
            )
        }
    }
}

@MainActor
enum LocationsViewModelAssembler {
    static func make(
        locationsProvider: LocationsProvider,
        openUrl: @escaping (URL) -> Void
    ) -> LocationsViewModel {
        let navigator = WikipediaLocationNavigator(
            openUrl: openUrl
        )
        let viewModel = LocationsViewModel(
            locationsProvider: locationsProvider,
            onLocationSelection: navigator.showLocationOnWikipedia
        )
        return viewModel
    }
}
