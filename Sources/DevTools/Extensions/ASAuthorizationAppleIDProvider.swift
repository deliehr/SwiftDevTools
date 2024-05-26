//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import AuthenticationServices

public extension ASAuthorizationAppleIDProvider {
    func getCredentialState(forUserID userID: String) async throws -> ASAuthorizationAppleIDProvider.CredentialState {
        try await withCheckedThrowingContinuation { continuation in
            getCredentialState(forUserID: userID) { state, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: state)
            }
        }
    }
}
