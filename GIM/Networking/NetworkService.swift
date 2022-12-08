//
//  Api.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//
import Alamofire

class NetworkService {
    private static let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private let baseURL = "https://api.rawg.io/api/games"
    static var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension NetworkService {
    fileprivate func baseRequest<T: Decodable>(
        _ endPoint: String? = nil,
        parameters: [String: String],
        decodeable: T.Type = T.self,
        completionHandler: @escaping (
            _ value: T?) -> Void) {
                AF.request(baseURL + "\(endPoint ?? "")", parameters: parameters)
                    .validate()
                    .responseDecodable(of: decodeable) { response in
                        switch response.result {
                        case.success(let value):
                            completionHandler(value)
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
            }
    func fetchNewReleaseGames(
        completionHandler: @escaping (
            _ newReleaseGames: [Game]) -> Void) {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"
                let thisMonth = formatter.string(from: date)
                guard let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else {return}
                let lastMonth = formatter.string(from: lastMonthDate)
                let parameters: [String: String] = [
                    "key": NetworkService.apiKey,
                    "dates": "\(lastMonth),\(thisMonth)"
                ]
                baseRequest(parameters: parameters, decodeable: GamesResponses.self) { value in
                    guard let value = value else {return}
                    let gameData = self.gamesMapper(input: value.games)
                    completionHandler(gameData)
                }
            }
    func searchGames(key keyword: String, completionHandler: @escaping (
        _ games: [Game]) -> Void) {
            let parameters: [String: String] = [
                "key": NetworkService.apiKey,
                "search": keyword
            ]
            baseRequest(parameters: parameters, decodeable: GamesResponses.self) { value in
                guard let value = value else {return}
                let gameData = self.gamesMapper(input: value.games)
                completionHandler(gameData)
            }
        }
    func fetchGames(completionHandler: @escaping (_ games: [Game]) -> Void) {
        let parameters: [String: String] = [
            "key": NetworkService.apiKey
        ]
        baseRequest(parameters: parameters, decodeable: GamesResponses.self) { value in
            guard let value = value else {return}
            let gameData = self.gamesMapper(input: value.games)
            completionHandler(gameData)
        }
    }
    func fetchGame(
        fromId id: Int,
        completionHandler: @escaping (_ game: Game) -> Void) {
            let parameters: [String: String] = [
                "key": NetworkService.apiKey
            ]
            baseRequest("/\(id)", parameters: parameters, decodeable: GameResponse.self) { value in
                guard let value = value else {return}
                let gameData = self.gameMapper(input: value)
                completionHandler(gameData)
            }
        }
}

extension NetworkService {
    fileprivate func gamesMapper(
        input gamesResponses: [GameResponse]
    ) -> [Game] {
        return gamesResponses.map { result in
            Game(
                id: result.id,
                name: result.name,
                released: result.released,
                imagePath: result.imagePath,
                rating: result.rating,
                genres: result.genresString,
                descriptionRaw: result.description,
                ratingCount: result.ratingsCount,
                parentPlatformNames: result.parentPlatforms,
                developers: developerMapper(input: result.developers ?? []))
        }
    }
    fileprivate func gameMapper(
        input gameResponse: GameResponse
    ) -> Game {
        return Game(
            id: gameResponse.id,
            name: gameResponse.name,
            released: gameResponse.released,
            imagePath: gameResponse.imagePath,
            rating: gameResponse.rating,
            genres: gameResponse.genresString,
            descriptionRaw: gameResponse.description,
            ratingCount: gameResponse.ratingsCount,
            parentPlatformNames: gameResponse.parentPlatforms,
            developers: developerMapper(input: gameResponse.developers!))
    }
    fileprivate func developerMapper(
        input developersResponses: [DeveloperResponse]
    ) -> [Developer] {
        return developersResponses.map { developer in
            Developer(name: developer.name, imagePath: developer.imagePath)
        }
    }
}
