//
//  URLDate.swift
//  CC
//
//  Created by Алексей on 12/3/20.
//

import Foundation

struct URLDate: Codable {
    let rates: [String: Double]
    let base: String
    let date: String
}
