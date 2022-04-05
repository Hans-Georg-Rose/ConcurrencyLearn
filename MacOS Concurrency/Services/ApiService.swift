//
//  ApiService.swift
//  MacOS Concurrency
//
//  Created by Hans-Georg Rose on 31.03.22.
//

import Foundation

struct APIService {
    
    let urlString: String

    // MARK: Create a variant of getJSON for the Async & Await concurrency method
    
    func getJSON <T: Decodable> (dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {

        // check url

        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        
        // call the async version of URLSession, must be in a try as throwing and must exist only in a async function block
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                // Decode
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch { // process all eventually occuring errors as URLsession.shard.data is throwing
            throw APIError.dataTaskError(error.localizedDescription)
        }

        
    }

    // MARK: Create a variant of getJSON closure variant

    // Works with any decodable type: <T: Decodable>, where T is the placeholder
    
    func getJSON <T: Decodable> (dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                 completion: @escaping (Result<T, APIError>) -> Void) {
        
        // completion: Completion Handler as we do not know when this function finishes
        // Result of the completion handler will be an array of user OR an error
        
        guard
            let url = URL(string: urlString)
        else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Using the URLSession singleton. Initiallz suspended, thus .resume() to
        // start the task
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check HTTP Status Code is 200 ==> OK
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponseStatus))
                return
            }
            // Check if there is any error
            guard
                error == nil
            else {
                completion(.failure(.dataTaskError(error!.localizedDescription)))
                return
            }
            // Check if we have gotten back any data. If not, just return
            guard
                let data = data // data is not nil? Unwrap
            else {
                completion(.failure(.corruptData))
                return
            }
            // Now we can try to decode the data with the JSONDecoder
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                // Decode
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData)) // Call the completionhandler, pass array of user
            } catch {
                // Catch error
                print("Error to JSON decode array of USER")
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        .resume()
    }
    
}

// Desriptive definitions of the possible error cases in the above JSPN Decoding

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    // Translate the APIError status into a human readable error description
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
