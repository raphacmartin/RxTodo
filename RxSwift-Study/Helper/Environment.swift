//
//  Environment.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 11/27/22.
//

import Foundation

public final class Environment {
    public static var apiUrl: URL {
        guard let _apiUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as? String, let _apiUrl = URL(string: _apiUrl) else {
            fatalError("Unable to read the API URL from the Info.plist file")
        }
        
        return _apiUrl
    }
}
