//
//  ShowsListModel.swift
//  TV Shows
//
//  Created by Kiran R on 22/09/21.
//

import Foundation


// MARK: - ShowsListModel
class ShowsListModel: Codable {
    let id: Int
    let url: String
    let name: String
    let type: TypeEnum
    let language: Language
    let genres: [String]
    let status: Status
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let network, webChannel: Network?
    let dvdCountry: JSONNull?
    let externals: Externals
    let image: Image
    let summary: String
    let updated: Int
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime, premiered, ended, officialSite, schedule, rating, weight, network, webChannel, dvdCountry, externals, image, summary, updated
        case links = "_links"
    }

    init(id: Int, url: String, name: String, type: TypeEnum, language: Language, genres: [String], status: Status, runtime: Int?, averageRuntime: Int?, premiered: String?, ended: String?, officialSite: String?, schedule: Schedule, rating: Rating, weight: Int, network: Network?, webChannel: Network?, dvdCountry: JSONNull?, externals: Externals, image: Image, summary: String, updated: Int, links: Links) {
        self.id = id
        self.url = url
        self.name = name
        self.type = type
        self.language = language
        self.genres = genres
        self.status = status
        self.runtime = runtime
        self.averageRuntime = averageRuntime
        self.premiered = premiered
        self.ended = ended
        self.officialSite = officialSite
        self.schedule = schedule
        self.rating = rating
        self.weight = weight
        self.network = network
        self.webChannel = webChannel
        self.dvdCountry = dvdCountry
        self.externals = externals
        self.image = image
        self.summary = summary
        self.updated = updated
        self.links = links
    }
}

// MARK: - Externals
class Externals: Codable {
    let tvrage: Int
    let thetvdb: Int?
    let imdb: String?

    init(tvrage: Int, thetvdb: Int?, imdb: String?) {
        self.tvrage = tvrage
        self.thetvdb = thetvdb
        self.imdb = imdb
    }
}

// MARK: - Image
class Image: Codable {
    let medium, original: String

    init(medium: String, original: String) {
        self.medium = medium
        self.original = original
    }
}

enum Language: String, Codable {
    case english = "English"
    case japanese = "Japanese"
}

// MARK: - Links
class Links: Codable {
    let linksSelf: Nextepisode
    let previousepisode, nextepisode: Nextepisode?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case previousepisode, nextepisode
    }

    init(linksSelf: Nextepisode, previousepisode: Nextepisode?, nextepisode: Nextepisode?) {
        self.linksSelf = linksSelf
        self.previousepisode = previousepisode
        self.nextepisode = nextepisode
    }
}

// MARK: - Nextepisode
class Nextepisode: Codable {
    let href: String

    init(href: String) {
        self.href = href
    }
}

// MARK: - Network
class Network: Codable {
    let id: Int
    let name: String
    let country: Country?

    init(id: Int, name: String, country: Country?) {
        self.id = id
        self.name = name
        self.country = country
    }
}

// MARK: - Country
class Country: Codable {
    let name: Name
    let code: Code
    let timezone: Timezone

    init(name: Name, code: Code, timezone: Timezone) {
        self.name = name
        self.code = code
        self.timezone = timezone
    }
}

enum Code: String, Codable {
    case ca = "CA"
    case fr = "FR"
    case gb = "GB"
    case jp = "JP"
    case us = "US"
}

enum Name: String, Codable {
    case canada = "Canada"
    case france = "France"
    case japan = "Japan"
    case unitedKingdom = "United Kingdom"
    case unitedStates = "United States"
}

enum Timezone: String, Codable {
    case americaHalifax = "America/Halifax"
    case americaNewYork = "America/New_York"
    case asiaTokyo = "Asia/Tokyo"
    case europeLondon = "Europe/London"
    case europeParis = "Europe/Paris"
}

// MARK: - Rating
class Rating: Codable {
    let average: Double?

    init(average: Double?) {
        self.average = average
    }
}

// MARK: - Schedule
class Schedule: Codable {
    let time: String
    let days: [Day]

    init(time: String, days: [Day]) {
        self.time = time
        self.days = days
    }
}

enum Day: String, Codable {
    case friday = "Friday"
    case monday = "Monday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    case thursday = "Thursday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
}

enum Status: String, Codable {
    case ended = "Ended"
    case running = "Running"
    case toBeDetermined = "To Be Determined"
}

enum TypeEnum: String, Codable {
    case animation = "Animation"
    case documentary = "Documentary"
    case news = "News"
    case panelShow = "Panel Show"
    case reality = "Reality"
    case scripted = "Scripted"
    case sports = "Sports"
    case talkShow = "Talk Show"
    case variety = "Variety"
}

typealias Welcome = [ShowsListModel]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
