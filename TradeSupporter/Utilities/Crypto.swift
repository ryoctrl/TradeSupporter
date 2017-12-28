//
//  Crypto.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/28.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        var result: [CUnsignedChar]
        if let ckey = key.cString(using: String.Encoding.utf8), let cdata = self.cString(using: String.Encoding.utf8) {
            result = Array(repeating: 0, count: Int(algorithm.digestLength))
            CCHmac(algorithm.HMACAlgorithm, ckey, ckey.count-1, cdata, cdata.count-1, &result)
        } else {
            fatalError("Nil returned when processing input strings as UTF8")
        }
        
        //return Data(bytes: result, count: result.count).base64EncodedString()
        /**/
        let hash = NSMutableString()
        for val in result {
            hash.appendFormat("%02hhx", val)
        }
        return hash as String
        /**/
    }
}
