//
//  SSCacheControl.swift
//  SSCacheControl
//
//  Created by LawLincoln on 15/12/22.
//  Copyright © 2015年 SelfStudio. All rights reserved.
//

import Foundation
import Alamofire

public typealias SSCacheControlConfig = (maxAge: NSTimeInterval, ignoreExpires: Bool, requestNewAfterRetrunCache: Bool)
private extension String {
	var date: NSDate! {
		let fmt = NSDateFormatter()
		fmt.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
		fmt.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		fmt.timeZone = NSTimeZone(abbreviation: "GMT")
		return fmt.dateFromString(self)
	}
}

public extension UIView {

	private struct AssociatedKeys {
		static var Config = "ss_firstTimeToken"
	}
	private var ss_firtime: Bool {
		get {
			return (objc_getAssociatedObject(self, &AssociatedKeys.Config) as? Bool) ?? true
		}
		set(max) {
			objc_setAssociatedObject(self, &AssociatedKeys.Config, max, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	func ss_cacheControlConfig(maxAge: NSTimeInterval) -> SSCacheControlConfig {
		var permision = false
		if ss_firtime {
			ss_firtime = false
			permision = true
		}
		return (maxAge: maxAge, ignoreExpires: permision, requestNewAfterRetrunCache: permision)
	}
}

extension NSURLRequest {

	private struct AssociatedKeys {
		static var MaxAge = "MaxAge"
	}
	var ll_max_age: NSTimeInterval {
		get {
			return (objc_getAssociatedObject(self, &AssociatedKeys.MaxAge) as? NSTimeInterval) ?? 0
		}
		set(max) {
			objc_setAssociatedObject(self, &AssociatedKeys.MaxAge, max, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	/**
	 Save NSHTTPURLResponse

	 - parameter maxAge: NSTimeInterval
	 - parameter resp:   NSHTTPURLResponse to store
	 - parameter data:   data to store
	 */

	func ll_storeResponse(maxAge: NSTimeInterval,
		resp: NSHTTPURLResponse?,
		data: NSData?) {
			if let response = resp, url = response.URL, header = response.allHeaderFields as? [String: String], data = data {
				if let re = NSHTTPURLResponse(URL: url, statusCode: response.statusCode, HTTPVersion: nil, headerFields: header) {
					let cachedResponse = NSCachedURLResponse(response: re, data: data, userInfo: nil, storagePolicy: NSURLCacheStoragePolicy.Allowed)
					NSURLCache.sharedURLCache().storeCachedResponse(cachedResponse, forRequest: self)
				}
			}
	}

	func ll_lastCachedResponseDataIgnoreExpires(ignoreExpires: Bool = true) -> NSData? {
		let response = NSURLCache.sharedURLCache().cachedResponseForRequest(self)
		if ignoreExpires {
			return response?.data
		}
		let now = NSDate()
		var data: NSData!
		if let resp = response?.response as? NSHTTPURLResponse {
			if let dateString = resp.allHeaderFields["Date"] as? String, dateExpires = dateString.date {
				let expires = dateExpires.dateByAddingTimeInterval(ll_max_age)
				if now.compare(expires) == .OrderedAscending {
					data = response?.data
				}
			}
		}
		return data
	}
}
