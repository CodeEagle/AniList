//
//  Router.swift
//  Pods
//
//  Created by LawLincoln on 16/5/19.
//
//

import UIKit
import SSCacheControl
import Alamofire
import WebKit

public enum AniAPI {

	public enum ResourceType: String { case anime = "anime", manga = "manga" }

	public enum CommonType: String { case anime = "anime", manga = "manga", character = "character", staff = "staff", actor = "actor", studio = "studio" }

	private static let _apiBase = "https://anilist.co/api/"
	/**
	 ClientAuthorization
	 - returns:
	 */
	case ClientAuthorization

	// MARK: Anime
	/// Returns up to 40 small anime models if paginating.
	case Browser(BrowserFilter?)

	/// List of genres for use with browse queries
	case GenreList

	case Search(String, CommonType)
	/**
	 Detail

	 - parameter String: anime id

	 - returns:
	 */
	case Detail(Int, CommonType)
	/**
	 AnimePage

	 - parameter String: anime id

	 - returns:
	 */
	case Page(Int, CommonType)

	case Characters(Int, ResourceType)
	case Staff(Int, ResourceType)
	case AnimeActors(Int)

	case AnimeAiring(Int)

	// MARK: Manga
	case MangaDetail(Int)
	case MangaPage(Int)

}

//MARK:- Path && Method
extension AniAPI {

	private var path: String {
		switch self {
		case .ClientAuthorization: return "auth/access_token"
		case .Browser: return "browse/anime"
		case .GenreList: return "genre_list"
		case .Search(let query, let type): return "\(type.rawValue)/search/\(query)"
		case .Detail(let id, let type): return "\(type.rawValue)/\(id)"
		case .Page(let id, let type): return "\(type.rawValue)/\(id)/page"
		case .Characters(let id, let type): return "\(type.rawValue)/\(id)/characters"
		case .Staff(let id, let type): return "\(type.rawValue)/\(id)/staff"
		case .AnimeActors(let id): return "anime/\(id)/actors"
		case .AnimeAiring(let id): return "anime/\(id)/airing"
		default: return ""
		}
	}

	private var method: Alamofire.Method {
		switch self {
		case .ClientAuthorization: return .POST
		default: return .GET
		}
	}

	private var requestingClientAuth: Bool {
		switch self {
		case .ClientAuthorization: return true
		default: return false
		}
	}

	private var requestingGenreList: Bool {
		switch self {
		case .GenreList: return true
		default: return false
		}
	}

}
import Gloss
extension AniAPI {

	public func execute<T: Decodable>(done: ([T?] -> Void)?) {
		func doRequest() {
			let previousRequest = self
			var cacheAge: SSCacheControlConfig = (1, true, true)
			if requestingClientAuth { cacheAge = (0, true, true) }
			let cacheConfig: (Result<NSData, NSError> -> Bool) = {
				result -> Bool in
				guard let value = result.value, json = try? NSJSONSerialization.JSONObjectWithData(value, options: .MutableLeaves) as? JSON else { return false }

				if let code = json?["status"] as? Int where code >= 400 && code < 500 {
					AniAPI.ClientAuthorization.execute { (_: [ClientAuthResult?]) in
						previousRequest.execute(done)
					}
					return false
				}
				return true
			}
			request(self, cacheControlMaxAge: cacheAge, queue: nil, canCacheResultClosure: cacheConfig) { (result) in
				guard let value = result.value, dat = try? NSJSONSerialization.JSONObjectWithData(value, options: .MutableLeaves) else { return }
				var ret: [T?] = []
				if let json = dat as? JSON {
					if self.requestingClientAuth {
						if let result = ClientAuthResult(json: json) {
							let date = NSDate(timeIntervalSince1970: NSTimeInterval(result.expires))
							AniAPIManager.manager.info = [result.accessToken: date]
						}
					}
					ret.append(T(json: json))
				} else if let value = dat as? [JSON] {
					value.forEach({ ret.append(T(json: $0)) })
					if self.requestingGenreList {
						AniAPIManager.manager.genreList = ret.flatMap({ (item) -> Genre? in
							return item as? Genre
						})
					}
				}
				done?(ret)

			}
		}
		if !requestingClientAuth && AniAPIManager.manager.validateToken == nil {
			AniAPI.ClientAuthorization.execute { (data: [ClientAuthResult?]) in
				doRequest()
			}
		} else {
			doRequest()
		}
	}
}

//MARK:- URLRequestConvertible
extension AniAPI: URLRequestConvertible {

	public var URLRequest: NSMutableURLRequest {
		let baseURL = NSURL(string: AniAPI._apiBase)!
		let mutableURLRequest = NSMutableURLRequest(URL: baseURL.URLByAppendingPathComponent(path), cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
		mutableURLRequest.HTTPMethod = method.rawValue
		if let token = AniAPIManager.manager.validateToken {
			mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
		}
		var param = Param()
		switch self {
		case .ClientAuthorization:
			param["grant_type"] = "client_credentials"
			param["client_id"] = AniAPIManager.manager.clientId
			param["client_secret"] = AniAPIManager.manager.clientSecret
		case .Browser(let filter):
			if let f = filter {
				param = f.param
			}
		default: break
		}
		return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: param).0
	}

}

public class AniAPIManager {

	private static var _sharedStore: AniAPIManager? = nil

	public static var manager: AniAPIManager! {
		guard let value = _sharedStore else {
			assert(false, "must use initWith: once")
			return nil
		}
		return value
	}

	public static func register(clientId: String, clientSecret: String/*, redirectUri: String*/) -> AniAPIManager {
		_sharedStore = AniAPIManager(clientId: clientId, clientSecret: clientSecret/*, redirectUri: redirectUri*/)
		return _sharedStore!
	}

	init (clientId: String, clientSecret: String/*, redirectUri: String*/) {
		self.clientId = clientId
		self.clientSecret = clientSecret
//		self.redirectUri = redirectUri
		guard let value = NSUserDefaults.standardUserDefaults().objectForKey("AniClientAuth") as? [String: NSDate] else { return }
		info = value
	}

	var info: [String: NSDate]? = nil {
		didSet {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
				let config = NSUserDefaults.standardUserDefaults()
				config.setObject(self.info, forKey: "AniClientAuth")
				config.synchronize()
			})
		}
	}

	var genreList: [Genre] = [] {
		didSet {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
				let config = NSUserDefaults.standardUserDefaults()
				config.setObject(self.genreList.json, forKey: "AniGenreList")
				config.synchronize()
			})
		}
	}

	public var lastGenreList: [Genre] {
		if genreList.count == 0 {
			let request = AniAPI.GenreList.URLRequest
			if let data = NSURLCache.sharedURLCache().cachedResponseForRequest(request)?.data {
				let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves)
				guard let list = json as? [JSON] else { return [] }
				let total = list.flatMap { (item) -> Genre? in
					return Genre(json: item)
				}
				genreList = total
			}
		}
		return genreList
	}

	private(set) var clientId: String? = nil
	private(set) var clientSecret: String? = nil
//	private(set) var redirectUri: String? = nil

	var validateToken: String? {
		guard let value = info else { return nil }
		let now = NSDate()
		var token: String? = nil
		value.forEach { (key, value) in
			if now.laterDate(value) == value { token = key }
		}
		return token
	}

}

//MARK: BrowserAnimateFilter
public struct BrowserFilter {
	/// 4 digit year e.g. "2014"
	public var year: Int?
	public var season: BrowserSeason?
	public var type: BrowserType?
	public var status: BrowserStatus?
	/// Comma separated genre strings. e.g. "Action, Comedy" Returns anime that have ALL the genres.
	public var genres: [Genre]?
	/// Comma separated genre strings. e.g. "Drama" Excludes returning anime that have ANY of the genres.
	public var genres_exclude: [Genre]?
	public var sort: BrowserSort?
	public var sortDesc: Bool?
	/// "airing_data = true" Includes anime airing data in small models
	public var includeAiringData: Bool?
	/// "full_page = true" Returns all available results. Ignores pages. Only available when status="Currently Airing" or season is included
	public var full_page: Bool?
	public var page: Int?
	public var resourceType: AniAPI.ResourceType = .anime

	public init() { }
	var param: Param {
		var value = Param()
		let animeOnly = resourceType == .anime
		if let y = year {
			assert(y > 1000, "4 digit year e.g.2014")
			value["year"] = y
		}
		if let s = season where animeOnly { value["season"] = s.rawValue }
		if let t = type {
			if t.validateFor(resourceType) { value["type"] = t.rawValue }
			else { assert(false, "value:\(t) is not fit for:\(resourceType) ") }
		}
		if let s = status {
			if s.validateFor(resourceType) { value["status"] = s.rawValue }
			else { assert(false, "value:\(s) is not fit for:\(resourceType) ") }
		}
		if let g = genres {
			let flat = g.flatMap({ (genre) -> String? in
				return genre.genre
			})
			value["genres"] = flat.joinWithSeparator(", ")
		}
		if let g = genres_exclude {
			let flat = g.flatMap({ (genre) -> String? in
				return genre.genre
			})
			value["genres_exclude"] = flat.joinWithSeparator(", ")
		}
		if let s = sort {
			if sortDesc == true {
				value["sort"] = s.descOrder
			} else {
				value["sort"] = s.rawValue
			}
		}
		if includeAiringData == true { value["airing_data"] = true }
		if full_page == true && animeOnly { value["full_page"] = true }
		if let p = page { value["page"] = p }
		return value
	}
}

extension Array where Element: Encodable {

	var json: [JSON] {
		var total = [JSON]()
		forEach { (item) in
			if let json = item.toJSON() {
				total.append(json)
			}
		}
		return total
	}
}

//MARK:- typealias
public typealias Param = [String: AnyObject]

//MARK:- Enum
/// "id" || "score" || "popularity" || "start date" || "end date" Sorts results, default ascending order. Append " - desc" for descending order e.g. "id - desc"
public enum BrowserSort: String {
	case id = "id"
	case score = "score"
	case popularity = "popularity"
	case startDate = "start date"
	case endDate = "end date"

	public var descOrder: String { return rawValue + " - desc" }
}
public enum BrowserStatus: String {
	// For Anime
	case notYetAired = "not yet aired"
	case currentlyAiring = "currently airing"
	case finishedAiring = "finished airing"
	case cancelled = "cancelled"
	// For Manga
	case notYetPublished = "not yet published"
	case currentlyPublishing = "currently publishing"
	case finished = "finished"

	func validateFor(type: AniAPI.ResourceType) -> Bool {
		let anime: [BrowserStatus] = [.notYetAired, .currentlyAiring, .finishedAiring, .cancelled]
		let manga: [BrowserStatus] = [.notYetPublished, .currentlyPublishing, .finished, .cancelled]
		if type == .anime { return anime.contains(self) }
		else { return manga.contains(self) }
	}
}

public enum BrowserSeason: String {
	case spring = "spring"
	case summer = "summer"
	case fall = "fall"
	case winter = "winter"
}

public enum BrowserType: String {
	// For Anime
	case tv = "TV"
	case movie = "Movie"
	case special = "Special"
	case ova = "OVA"
	case ona = "ONA"
	case tvShort = "TV Short"
	// For Manga
	case manga = "Manga"
	case novel = "Novel"
	case manhua = "Manhua"
	case manhwa = "Manhwa"
	case one = "One"
	case doujin = "Doujin"

	func validateFor(type: AniAPI.ResourceType) -> Bool {
		let anime: [BrowserType] = [.tv, .movie, .special, .ova, .ona, .tvShort]
		let manga: [BrowserType] = [.manga, .manhua, .manhwa, .novel, .one, .doujin]
		if type == .anime { return anime.contains(self) }
		else { return manga.contains(self) }
	}
}
