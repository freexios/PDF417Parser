//
//  LicenseParsingTest.swift
//  Parser
//
//  Created by Nikolai Prokofev on 2020-02-02.
//  Copyright © 2020 Nikolai Prokofev. All rights reserved.
//

import UIKit

var s = """
@\n\u{1E}\rANSI 636012030001DL00000367DLDCAG1 \nDCBX\nDCDNONE \nDBA20210520\nDCSMALAIYA,\nDCTNIRAJANA\nDBD20160627\nDBB19800306\nDBC2\nDAYNONE\nDAU160 cm\nDAG1017-16FAKE HALL DR, \nDAITORONTO \nDAJON\nDAKM4N 1B6\nDAQM0233-60409-25311\nDCFDN2962102\nDCGCAN\nDCHNONE\nDCK*9989695*\n\r
"""

struct DriverLicense: Codable {
    let firstName              : String?
    let lastName               : String?
    let middleName             : String?
    let expirationDate         : String?
    let issueDate              : String?
    let dateOfBirth            : String?
    let gender                 : String?
    let eyeColor               : String?
    let height                 : String?
    let streetAddress          : String?
    let city                   : String?
    let state                  : String?
    let postalCode             : String?
    let customerId             : String?
    let documentId             : String?
    let country                : String?
    let middleNameTruncation   : String?
    let firstNameTruncation    : String?
    let lastNameTruncation     : String?
    let streetAddressSupplement: String?
    let hairColor              : String?
    let placeOfBirth           : String?
    let auditInformation       : String?
    let inventoryControlNumber : String?
    let lastNameAlias          : String?
    let firstNameAlias         : String?
    let suffixAlias            : String?
    let suffix                 : String?
}

class Parser {
    private let fields: [String: String] = [
        "firstName"               : "DCT",
        "lastName"                : "DCS",
        "middleName"              : "DAD",
        "expirationDate"          : "DBA",
        "issueDate"               : "DBD",
        "dateOfBirth"             : "DBB",
        "gender"                  : "DBC",
        "eyeColor"                : "DAY",
        "height"                  : "DAU",
        "streetAddress"           : "DAG",
        "city"                    : "DAI",
        "state"                   : "DAJ",
        "postalCode"              : "DAK",
        "customerId"              : "DAQ",
        "documentId"              : "DCF",
        "country"                 : "DCG",
        "middleNameTruncation"    : "DDG",
        "firstNameTruncation"     : "DDF",
        "lastNameTruncation"      : "DDE",
        "streetAddressSupplement" : "DAH",
        "hairColor"               : "DAZ",
        "placeOfBirth"            : "DCI",
        "auditInformation"        : "DCJ",
        "inventoryControlNumber"  : "DCK",
        "lastNameAlias"           : "DBN",
        "firstNameAlias"          : "DBG",
        "suffixAlias"             : "DBS",
        "suffix"                  : "DCU"
    ]
    
    func parsePDF417(_ string: String, _ completion: (Result<DriverLicense, Error>)->()) {
        var values = [String:String]()
        let range = NSRange(location: 0, length: string.utf16.count)
        
        for (k, v) in fields {
            let regex = try! NSRegularExpression(pattern: "(?<=\(v)).*?(?=\\n| \\n|, \\n)")
            guard let result = regex.firstMatch(in: string, options: [], range: range) else { continue }
            guard let range = Range(result.range, in: string) else { continue }
            values[k] = String(string[range])
        }
        completion(getDriverLicense(from: values))
    }
    
    private func getDriverLicense(from dictionary: [String: String])-> Result<DriverLicense, Error> {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let license = try JSONDecoder().decode(DriverLicense.self, from: data)
            return (.success(license))
        } catch {
            return (.failure(error))
        }
    }
}
