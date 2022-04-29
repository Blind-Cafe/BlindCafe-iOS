//
//  MyAuthenticator.swift
//  BlindCafe
//
//  Created by 권하은 on 2022/04/18.
//

import Foundation
import Alamofire

class MyAuthenticator: Authenticator {
    typealias Credential = MyAuthenticationCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        // bearerToken의 urlRequest대해서만 refresh를 시도 (true)
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        let input = RefreshInput(refreshToken: UserDefaults.standard.string(forKey: "UserJwt") ?? "")
        
        AF.request("\(Constant.BASE_URL)/api/auth/refresh", method: .post, parameters: input, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: RefreshResponse.self) { response in
                switch response.result {
                case .success( _):
                   completion(.success(credential))
                case .failure(let error):
                   completion(.failure(error))
                }
            }
        
    }
}
