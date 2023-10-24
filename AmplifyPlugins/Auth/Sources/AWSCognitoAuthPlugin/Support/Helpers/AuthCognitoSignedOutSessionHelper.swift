//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import AWSPluginsCore

struct AuthCognitoSignedOutSessionHelper {

    /// Creates a signedOut session information with valid identityId and aws credentials.
    /// - Parameters:
    ///   - identityId: Valid identity id for the current signedOut session
    ///   - awsCredentials: Valid AWS Credentials for the current signedOut session
    /// - Returns: Returns a valid signedOut session
    static func makeSignedOutSession(identityId: String,
                                     awsCredentials: AWSCredentials) -> AWSAuthCognitoSession {
        let tokensError = makeCognitoTokensSignedOutError()
        let authSession = AWSAuthCognitoSession(isSignedIn: false,
                                                identityIdResult: .success(identityId),
                                                awsCredentialsResult: .success(awsCredentials),
                                                cognitoTokensResult: .failure(tokensError))
        return authSession
    }

    /// Guest/SignOut session when the guest access is not enabled.
    /// - Returns: Session with isSignedIn = false
    static func makeSessionWithNoGuestAccess() -> AWSAuthCognitoSession {
        let identityIdError = AuthError.service(
            AuthPluginErrorConstants.identityIdSignOutError.errorDescription,
            AuthPluginErrorConstants.identityIdSignOutError.recoverySuggestion,
            AWSCognitoAuthError.invalidAccountTypeException)

        let awsCredentialsError = AuthError.service(
            AuthPluginErrorConstants.awsCredentialsSignOutError.errorDescription,
            AuthPluginErrorConstants.awsCredentialsSignOutError.recoverySuggestion,
            AWSCognitoAuthError.invalidAccountTypeException)

        let tokensError = makeCognitoTokensSignedOutError()

        let authSession = AWSAuthCognitoSession(isSignedIn: false,
                                                identityIdResult: .failure(identityIdError),
                                                awsCredentialsResult: .failure(awsCredentialsError),
                                                cognitoTokensResult: .failure(tokensError))
        return authSession
    }

    /// Guest/SignedOut session with couldnot retreive either aws credentials or identity id.
    /// - Returns: Session will have isSignedIn = false
    private static func makeSignedOutSessionWithServiceIssue() -> AWSAuthCognitoSession {

        let identityIdError = AuthError.service(
            AuthPluginErrorConstants.identityIdServiceError.errorDescription,
            AuthPluginErrorConstants.identityIdServiceError.recoverySuggestion)

        let awsCredentialsError = AuthError.service(
            AuthPluginErrorConstants.awsCredentialsServiceError.errorDescription,
            AuthPluginErrorConstants.awsCredentialsServiceError.recoverySuggestion)

        let tokensError = makeCognitoTokensSignedOutError()

        let authSession = AWSAuthCognitoSession(isSignedIn: false,
                                                identityIdResult: .failure(identityIdError),
                                                awsCredentialsResult: .failure(awsCredentialsError),
                                                cognitoTokensResult: .failure(tokensError))
        return authSession
    }

    private static func makeCognitoTokensSignedOutError() -> AuthError {
        let tokensError = AuthError.signedOut(
            AuthPluginErrorConstants.cognitoTokensSignOutError.errorDescription,
            AuthPluginErrorConstants.cognitoTokensSignOutError.recoverySuggestion)
        return tokensError
    }
}
