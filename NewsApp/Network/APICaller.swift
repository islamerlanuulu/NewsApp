//
//  APICaller.swift
//  NewsApp
//
//  Created by Islam  EU on 24/1/24.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2023-12-24&sortBy=publishedAt&apiKey=edc101d19d8c48b6a029d472866769df")
    }
    
    
    private init() {}
    
    
    public func getTopStories(completion: @escaping (Result<[Article ], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error  {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch {
                    completion(.failure(error))
                    
                }
            }
        }
        
        task.resume()
    }
}
