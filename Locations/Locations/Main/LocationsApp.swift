//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

private let session = URLSession(configuration: .ephemeral)
private let httpClient = UrlSessionHttpClient(session: session)
private let locationProvider = RemoteLocationsProvider(httpClient: httpClient)

@main
struct LocationsApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsView(
                viewModel: LocationsViewModelAssembler.make(
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
        let mapper = PresentableLocationMapper(
            onLocationSelection: navigator.showLocationOnWikipedia
        )
        let viewModel = LocationsViewModel(
            locationsProvider: locationsProvider,
            mapToPresentableLocations: mapper.mapToPresentableLocations
        )
        return viewModel
    }
}
