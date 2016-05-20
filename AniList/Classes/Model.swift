//
//  Model.swift
//  Pods
//
//  Created by LawLincoln on 16/5/20.
//
//
import Foundation
import Gloss
//MARK:- Public

//MARK: - Anime
public struct Anime: Glossy {
	public let id: Int!
	public let titleRomaji: String!
	public let titleJapanese: String?
	public let titleEnglish: String?
	public let type: BrowserType?
	public let imageUrlSml: String!
	public let imageUrlMed: String!
	public let imageUrlLge: String!
	public let synonyms: [String]!
	public let airingStatus: BrowserStatus?
	public let averageScore: String!
	public let totalEpisodes: Int!
	public let adult: Bool!
	public let popularity: Int!
	public let relationType: AnyObject?
	public let role: String?

	public let startDate: String?
	public let endDate: String?
	public let classification: String?
	public let hashtag: String?
	public let source: String?
	public let description: String?
	public let genres: [Genre]?
	public let duration: Int?
	public let youtubeId: String?
	public let listStats: String?
	public let airing: String?

	// MARK:- Decodable
	public init?(json: JSON) {
		id = "id" <~~ json
		titleRomaji = "title_romaji" <~~ json
		titleJapanese = "title_japanese" <~~ json
		titleEnglish = "title_english" <~~ json
		type = "type" <~~ json
		imageUrlSml = "image_url_sml" <~~ json
		imageUrlMed = "image_url_med" <~~ json
		imageUrlLge = "image_url_lge" <~~ json
		synonyms = "synonyms" <~~ json
		airingStatus = "airing_status" <~~ json
		averageScore = "average_score" <~~ json
		totalEpisodes = "total_episodes" <~~ json
		adult = "adult" <~~ json
		popularity = "popularity" <~~ json
		relationType = "relation_type" <~~ json
		role = "role" <~~ json
		startDate = "start_date" <~~ json
		endDate = "end_date" <~~ json
		classification = "classification" <~~ json
		hashtag = "hashtag" <~~ json
		source = "source" <~~ json
		description = "description" <~~ json
		genres = "genres" <~~ json
		duration = "duration" <~~ json
		youtubeId = "youtube_id" <~~ json
		listStats = "list_stats" <~~ json
		airing = "airing" <~~ json
	}

	// MARK:- Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"id" ~~> id,
			"title_romaji" ~~> titleRomaji,
			"title_japanese" ~~> titleJapanese,
			"title_english" ~~> titleEnglish,
			"type" ~~> type,
			"image_url_sml" ~~> imageUrlSml,
			"image_url_med" ~~> imageUrlMed,
			"image_url_lge" ~~> imageUrlLge,
			"synonyms" ~~> synonyms,
			"average_score" ~~> averageScore,
			"total_episodes" ~~> totalEpisodes,
			"adult" ~~> adult,
			"popularity" ~~> popularity,
			"relation_type" ~~> relationType,
			"role" ~~> role,
			"start_date" ~~> startDate,
			"end_date" ~~> endDate,
			"classification" ~~> classification,
			"hashtag" ~~> hashtag,
			"source" ~~> source,
			"description" ~~> description,
			"genres" ~~> genres,
			"duration" ~~> duration,
			"youtube_id" ~~> youtubeId,
			"list_stats" ~~> listStats,
			"airing" ~~> airing
		])
	}
}

//MARK: Airing
public struct Airing: Glossy {

	public let countdown: Int!
	public let nextEpisode: Int!
	public let time: String!

	// MARK: Decodable
	public init?(json: JSON) {
		countdown = "countdown" <~~ json
		nextEpisode = "next_episode" <~~ json
		time = "time" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"countdown" ~~> countdown,
			"next_episode" ~~> nextEpisode,
			"time" ~~> time,
		])
	}

}

//MARK:  ListStat
public struct ListStat: Glossy {

	public let completed: Int!
	public let dropped: Int!
	public let onHold: Int!
	public let planToWatch: Int!
	public let watching: Int!

	// MARK: Decodable
	public init?(json: JSON) {
		completed = "completed" <~~ json
		dropped = "dropped" <~~ json
		onHold = "on_hold" <~~ json
		planToWatch = "plan_to_watch" <~~ json
		watching = "watching" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"completed" ~~> completed,
			"dropped" ~~> dropped,
			"on_hold" ~~> onHold,
			"plan_to_watch" ~~> planToWatch,
			"watching" ~~> watching,
		])
	}

}

//MARK: - Genre
public struct Genre: Glossy {
	public let genre: String
	public let id: Int

	public init?(json: JSON) {
		guard let g = json["genre"] as? String,
			i = json["id"] as? Int else { return nil }
		genre = g
		id = i
	}

	public func toJSON() -> JSON? {
		return jsonify([
			"id" ~~> id,
			"genre" ~~> genre
		])
	}
}

//MARK: - Manga
public struct Manga: Glossy {

	public let adult: Bool!
	public let averageScore: String!
	public let descriptionField: String!
	public let endDate: String!
	public let genres: [String]!
	public let id: Int!
	public let imageUrlBanner: String?
	public let imageUrlLge: String!
	public let imageUrlMed: String!
	public let listStats: MangaListStat!
	public let popularity: Int!
	public let publishingStatus: BrowserStatus!
	public let relationType: AnyObject?
	public let role: String?
	public let startDate: String!
	public let synonyms: [String]!
	public let titleEnglish: String!
	public let titleJapanese: String!
	public let titleRomaji: String!
	public let totalChapters: Int!
	public let totalVolumes: Int!
	public let type: BrowserType!

	// MARK: Decodable
	public init?(json: JSON) {
		adult = "adult" <~~ json
		averageScore = "average_score" <~~ json
		descriptionField = "description" <~~ json
		endDate = "end_date" <~~ json
		genres = "genres" <~~ json
		id = "id" <~~ json
		imageUrlBanner = "image_url_banner" <~~ json
		imageUrlLge = "image_url_lge" <~~ json
		imageUrlMed = "image_url_med" <~~ json
		listStats = "list_stats" <~~ json
		popularity = "popularity" <~~ json
		publishingStatus = "publishing_status" <~~ json
		relationType = "relation_type" <~~ json
		role = "role" <~~ json
		startDate = "start_date" <~~ json
		synonyms = "synonyms" <~~ json
		titleEnglish = "title_english" <~~ json
		titleJapanese = "title_japanese" <~~ json
		titleRomaji = "title_romaji" <~~ json
		totalChapters = "total_chapters" <~~ json
		totalVolumes = "total_volumes" <~~ json
		type = "type" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"adult" ~~> adult,
			"average_score" ~~> averageScore,
			"description" ~~> descriptionField,
			"end_date" ~~> endDate,
			"genres" ~~> genres,
			"id" ~~> id,
			"image_url_banner" ~~> imageUrlBanner,
			"image_url_lge" ~~> imageUrlLge,
			"image_url_med" ~~> imageUrlMed,
			"list_stats" ~~> listStats,
			"popularity" ~~> popularity,
			"publishing_status" ~~> publishingStatus,
			"relation_type" ~~> relationType,
			"role" ~~> role,
			"start_date" ~~> startDate,
			"synonyms" ~~> synonyms,
			"title_english" ~~> titleEnglish,
			"title_japanese" ~~> titleJapanese,
			"title_romaji" ~~> titleRomaji,
			"total_chapters" ~~> totalChapters,
			"total_volumes" ~~> totalVolumes,
			"type" ~~> type,
		])
	}

}

//MARK: MangaListStat
public struct MangaListStat: Glossy {

	public let completed: Int!
	public let dropped: Int!
	public let onHold: Int!
	public let planToRead: Int!
	public let reading: Int!

	// MARK: Decodable
	public init?(json: JSON) {
		completed = "completed" <~~ json
		dropped = "dropped" <~~ json
		onHold = "on_hold" <~~ json
		planToRead = "plan_to_read" <~~ json
		reading = "reading" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"completed" ~~> completed,
			"dropped" ~~> dropped,
			"on_hold" ~~> onHold,
			"plan_to_read" ~~> planToRead,
			"reading" ~~> reading,
		])
	}

}

//MARK: - Character
public struct Character: Glossy {

	public let id: Int!
	public let idActor: AnyObject!
	public let imageUrlLge: String!
	public let imageUrlMed: String!
	public let info: String!
	public let nameAlt: String!
	public let nameFirst: String!
	public let nameJapanese: String!
	public let nameLast: String!
	public let role: String?

	// MARK: Decodable
	public init?(json: JSON) {
		id = "id" <~~ json
		idActor = "id_actor" <~~ json
		imageUrlLge = "image_url_lge" <~~ json
		imageUrlMed = "image_url_med" <~~ json
		info = "info" <~~ json
		nameAlt = "name_alt" <~~ json
		nameFirst = "name_first" <~~ json
		nameJapanese = "name_japanese" <~~ json
		nameLast = "name_last" <~~ json
		role = "role" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"id" ~~> id,
			"id_actor" ~~> idActor,
			"image_url_lge" ~~> imageUrlLge,
			"image_url_med" ~~> imageUrlMed,
			"info" ~~> info,
			"name_alt" ~~> nameAlt,
			"name_first" ~~> nameFirst,
			"name_japanese" ~~> nameJapanese,
			"name_last" ~~> nameLast,
			"role" ~~> role,
		])
	}

}

//MARK: - Staff
public struct Staff: Glossy {

	public let dob: Int!
	public let id: Int!
	public let imageUrlLge: String!
	public let imageUrlMed: String!
	public let info: String!
	public let language: String!
	public let nameFirst: String!
	public let nameFirstJapanese: String!
	public let nameLast: String!
	public let nameLastJapanese: String!
	public let role: String?
	public let website: String!

	// MARK: Decodable
	public init?(json: JSON) {
		dob = "dob" <~~ json
		id = "id" <~~ json
		imageUrlLge = "image_url_lge" <~~ json
		imageUrlMed = "image_url_med" <~~ json
		info = "info" <~~ json
		language = "language" <~~ json
		nameFirst = "name_first" <~~ json
		nameFirstJapanese = "name_first_japanese" <~~ json
		nameLast = "name_last" <~~ json
		nameLastJapanese = "name_last_japanese" <~~ json
		role = "role" <~~ json
		website = "website" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
			"dob" ~~> dob,
			"id" ~~> id,
			"image_url_lge" ~~> imageUrlLge,
			"image_url_med" ~~> imageUrlMed,
			"info" ~~> info,
			"language" ~~> language,
			"name_first" ~~> nameFirst,
			"name_first_japanese" ~~> nameFirstJapanese,
			"name_last" ~~> nameLast,
			"name_last_japanese" ~~> nameLastJapanese,
			"role" ~~> role,
			"website" ~~> website,
		])
	}
}

//MARK: - Studio
public struct Studio: Glossy {

	public let id: Int!
	public let name: String!
	public let wiki: String?
	public let main: String?

	public init?(json: JSON) {
		id = "id" <~~ json
		name = "studio_name" <~~ json
		wiki = "studio_wiki" <~~ json
		main = "main_studio" <~~ json
	}

	public func toJSON() -> JSON? {
		return jsonify([
			"id" ~~> id,
			"studio_name" ~~> name,
			"studio_wiki" ~~> wiki,
			"main_studio" ~~> main
		])
	}
}

//MARK:- Private
//MARK: ClientAuthResult
struct ClientAuthResult: Glossy {
	let accessToken: String
	let tokenType: String
	let expires: Int
	let expiresIn: Int

	init?(json: JSON) {
		guard let _token = json["access_token"] as? String,
			_type = json["token_type"] as? String,
			_expires = json["expires"] as? Int,
			_expiresIn = json["expires_in"] as? Int
		else { return nil }
		accessToken = _token
		tokenType = _type
		expires = _expires
		expiresIn = _expiresIn
	}

	func toJSON() -> JSON? {
		return jsonify([
			"access_token" ~~> accessToken,
			"token_type" ~~> tokenType,
			"expires" ~~> expires,
			"expires_in" ~~> expiresIn
		])
	}

}