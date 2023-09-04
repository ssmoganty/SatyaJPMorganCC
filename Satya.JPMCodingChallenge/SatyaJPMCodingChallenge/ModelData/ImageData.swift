
import SwiftUI
import UIKit
import Combine

// ImageData object notify views when there's a change in the data from the API response.

final class ImageData: ObservableObject {
    var cancellable: AnyCancellable?
    
    let icon: String
    
    @Published var image: UIImage? = nil
    
    init(icon: String) {
        self.icon = icon
    }
    
    func loadImage() {
        cancellable = ImageService.shared.fetchImage(icon: icon)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageData.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
