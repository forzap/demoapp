//
//  Result.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U: Error> {
    case success
    case failure(U?)
}
