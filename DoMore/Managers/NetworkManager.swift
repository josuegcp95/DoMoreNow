//
//  NetworkManager.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit
import MusicKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    let imageCache = NSCache<NSString, UIImage>()
    var songs = [Item]()
    
    func fetchMusic(term: String, completed: @escaping (Result<[Item], DMError>) -> Void) async {
        var request = MusicCatalogSearchRequest(
            term: term,
            types: [Song.self])
        
        request.limit = 20
        
        do {
            let result =  try await request.response()
            self.songs = result.songs.compactMap({
                return .init(id: $0.id.rawValue,
                             name: $0.title,
                             artist: $0.artistName,
                             imageURL: $0.artwork?.url(width: 500, height: 500),
                             duration: $0.duration)
            })
            completed(.success(songs))
        } catch {
            completed(.failure(.unavailableConnection))
    }
}
    
    func requestAuthorization(completed: @escaping (DMError?) -> Void) async  {
        let status = await MusicAuthorization.request()
        
        switch status {
        case .authorized:
            completed(nil)
        case .denied:
            completed(.accessDenied)
        default:
            completed(.unavailableConnection)
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = imageCache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            imageCache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}


