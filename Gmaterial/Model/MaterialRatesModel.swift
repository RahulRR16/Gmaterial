//
//  MetalRatesModel.swift
//  Gmaterial
//
//

import Foundation

struct MaterialRatesModel : Codable {
    let code: Int?
    let data : DataModel?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(DataModel.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    static func parse(data: Data) -> MaterialRatesModel? {
        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(MaterialRatesModel.self, from: data)
            return responseModel
        } catch {
            print("Error parsing Metal Rates Model \(error.localizedDescription)")
            return nil
        }
    }
}

struct DataModel : Codable {
    var base: String?
    var timestamp: String?
    var rates: [String: Double]?
    var unit: String?
    
    enum CodingKeys: String, CodingKey {
        case base = "base"
        case rates = "rates"
        case timestamp = "timestamp"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        rates = try values.decodeIfPresent([String: Double].self, forKey: .rates)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
    }
}
