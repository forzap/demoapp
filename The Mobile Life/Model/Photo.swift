//
//  Photo.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

struct Photo: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
