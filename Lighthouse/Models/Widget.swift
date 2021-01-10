//
//  Widget.swift
//  Bulb
//
//  Created by Beiyi Xu on 10/19/20.
//

import Foundation
import MapKit

struct Widget {
    
    var id: String
    
    let user: User
    let question: String
    let answer: String
    let creationDate: Date
    let postType: Int
    let location: String
    let pdfUrl: String
    let a: Double
    let b: Int
    let c: Int
    let d: Int
    let e: Int
    let f: Int
    let g: Int
    let h: Int
    let i: Int
    let j: Int
    let k: Int
    let l: Int
    let m: Double
    let n: Int
    let o: Int
    let p: Int
    let q: Int
    
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.question = dictionary["question"] as? String ?? ""
        self.answer = dictionary["answer"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.postType = dictionary["postType"] as? Int ?? 1
        self.a = dictionary["a"] as? Double ?? 0
        self.b = dictionary["b"] as? Int ?? 0
        self.c = dictionary["c"] as? Int ?? 0
        self.d = dictionary["d"] as? Int ?? 0
        self.e = dictionary["e"] as? Int ?? 0
        self.f = dictionary["f"] as? Int ?? 0
        self.g = dictionary["g"] as? Int ?? 0
        self.h = dictionary["h"] as? Int ?? 0
        self.i = dictionary["i"] as? Int ?? 0
        self.j = dictionary["j"] as? Int ?? 0
        self.k = dictionary["k"] as? Int ?? 0
        self.l = dictionary["l"] as? Int ?? 0
        self.m = dictionary["m"] as? Double ?? 0
        self.n = dictionary["n"] as? Int ?? 0
        self.o = dictionary["o"] as? Int ?? 0
        self.p = dictionary["p"] as? Int ?? 0
        self.q = dictionary["q"] as? Int ?? 0
        self.location = dictionary["location"] as? String ?? "0:0"
        self.pdfUrl = dictionary["pdfUrl"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

