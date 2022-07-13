//
//  goods.swift
//  goodsAPP
//
//  Created by clark on 2022/06/08.


import Foundation

struct GoodsData: Codable {
    var name: String
    var num: Int
    var image: Data
}


//
//class goodsData: NSObject, NSCoding {
//    func encode(with coder: NSCoder) {
//        coder.encode(gName, forKey: "gName")
//                coder.encode(num, forKey: "num")
//                coder.encode(imageName, forKey: "imageName")
//    }
//
//    required init?(coder: NSCoder) {
//        gName = (coder.decodeObject(forKey: "gName") as? String) ?? ""
//        num =  coder.decodeInteger(forKey: "num")
//        imageName = (coder.decodeObject(forKey: "imageName") as? NSData) ?? NSData()
//    }
//
//
//
//        var gName: String
//        var num: Int
//        var imageName: NSData
//
//
//        init(_ gName: String, _ num: Int, _ imageName: NSData) {
//
//            self.gName = gName
//            self.num = num
//            self.imageName = imageName
//
//
//        }
//}
//
