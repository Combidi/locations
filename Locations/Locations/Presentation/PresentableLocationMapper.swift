//
//  Created by Peter Combee on 09/11/2024.
//

struct PresentableLocationMapper {
    
    private let onLocationSelection: (Location) -> Void
    
    init(onLocationSelection: @escaping (Location) -> Void) {
        self.onLocationSelection = onLocationSelection
    }
    
    func mapToPresentableLocations(locations: [Location]) -> [PresentableLocation] {
        locations.map { location in
            PresentableLocation(
                name: location.name,
                onSelection: { onLocationSelection(location) }
            )
        }
    }
}

