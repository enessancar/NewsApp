//
//  APICaller.swift
//  TopNewsApp
//
//  Created by Enes Sancar on 20.10.2022.
//

import Foundation

final class APICaller{
    
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-10-20&sortBy=popularity&apiKey=9f174ff4e9be4e9db85da7f5408f0970")
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping (Result<[Article] , Error>) -> Void) {
        
        guard let url = Constants.topHeadlinesURL else { return }
        
        let _: Void = URLSession.shared.dataTask(with: url) { data, _ , error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self , from: data)
                    completion(.success(result.articles))
                }catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

// Models

struct APIResponse: Codable{
    
    let articles: [Article]
}

struct Source: Codable {
    let name: String?
}

struct Article: Codable {
    
    let source: Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

