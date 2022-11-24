//
//  RatesRequest.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 24.11.2022.
//

import Foundation

class RatesRequest: APIRequest {
    var method = RequestType.GET
    var path = "rates"
 
}
