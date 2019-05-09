# OAuth

> https://developer.okta.com/blog/2017/06/21/what-the-heck-is-oauth

### What is OAuth

Standard that apps can use to provide client applications with “secure delegated access”. OAuth works over HTTPS and authorizes devices, APIs, servers, and applications with access tokens rather than credentials.

Direct Authentication Pattern

Federated identity created for single sign-on (SSO).  End user talks to identity provider, identity provider generates a cryptographically signed token which it hands off to the application to authenticate the user. The application trusts the identity provider.  As long as that trust relationship works with the signed assertion, you’re good to go.

### SAML

Main two components 

* authentication request protocol (aka Web SSO)
* packaging identity attributes and signs them, called SAML assertions

Okta does this with its SSO chiclets. Okta send a message, Okta sign the assertion, inside the assertion it says who the user is, and that it came from Okta. Slap a digital signature on it and you’re good to go.

SAML = session cookie in your browser that gives you access to webapps

Limited outside of a web browser.

SAML 2.0 (2005) made sense but lot changed now. Modern web, native application platforms. There are Single Page Applications (SPAs) like Gmail/Google Inbox, Facebook, and Twitter. They have different behaviors than your traditional web application, because they make AJAX (background HTTP calls) to APIs. Mobile phones make API calls too, as do TVs, gaming consoles, and IoT devices. SAML SSO isn’t particularly good at any of this.

### OAuth and APIs

Since 2005 web services now moved REST stateless APIs.

Need to protect REST APIs in a way allowing devices to access them. Old way enter username/password and login directly. This gave rise to the delegated authorization problem.

“How can I allow an app to access my data without necessarily giving it my password?”

If you’ve ever seen applications asking if it can access data on your behalf. This is OAuth.

***OAuth is a delegated authorization framework for REST/APIs. It enables apps to obtain limited access (scopes) to a user’s data without giving away a user’s password. It decouples authentication from authorization and supports multiple use cases addressing different device capabilities. It supports server-to-server apps, browser-based apps, mobile/native apps, and consoles/TVs.***

You can think of this like hotel key cards, but for apps. If you have a hotel key card, you can get access to your room. How do you get a hotel key card? You have to do an authentication process at the front desk to get it. After authenticating and obtaining the key card, you can access resources across the hotel.

To break it down simply, OAuth is where:

1. App requests authorization from User
1. User authorizes App and delivers proof
1. App presents proof of authorization to server to get a Token
1. Token is restricted to only access what the User authorized for the specific App

### OAuth Central Components

OAuth is built on the following central components:

* **Scopes and Consent** = bundles of permissions asked by client when requesting token
* **Actors** = Resource Owner, Resource Server, Client/Application, Authorization Service
* Clients = 
* Tokens = 
* Authorization Server = 
* Flows = 

### Scopes and Consent in OAuth

Scopes decouple authorization policy decisions from enforcement. Permissions listed in the API docs: here are the scopes that this app requires.

You have to capture this consent (trusting on first use). Now you have to authorize and give consent.  Consent can vary based on the application. It can be a time-sensitive range (day, weeks, months), but not all platforms allow you to choose the duration. One thing to watch for when you consent is that the app can do stuff on your behalf - e.g. LinkedIn spamming everyone in your network.

OAuth is an internet-scale solution because it’s per application. You often have the ability to log in to a dashboard to see what applications you’ve given access to and to revoke consent.

### Actors in OAuth

* **Resource Owner**: owns the data in the resource server. For example, I’m the Resource Owner of my Facebook profile.  Could also be company.
* **Resource Server**: The API which stores data the application wants to access
* **Client**: the application that wants to access your data
* **Authorization Server**: The main engine of OAuth

Clients can be public and confidential. Confidential clients can be trusted to store a secret. They’re not running on a desktop or distributed through an app store. People can’t reverse engineer them and get the secret key. They’re running in a protected area where end users can’t access them.

Public clients are browsers, mobile apps, and IoT devices.

### OAuth Tokens

**Clients use Access Tokens to access the Resource Server (API)**. Short-lived (hours/minutes). Designed for internet scale problems. Because short lived and scale out, can’t be revoked, wait for them to time out.

**The other token is the refresh token**. Longer-lived (days/months/years). Used to get refresh token, applications typically require confidential clients with authentication.

Refresh tokens can be revoked. Revoking application’s access = killing its refresh token. Forces clients to rotate secrets. Each new access token = new cryptographically signed token. Key rotation is built into the system.

**The OAuth token can any format. Usually JSON Web Tokens (JWT).** JWT (pronounced “jot”) is a secure and trustworthy standard for token authentication. JWTs allow you to digitally sign information (referred to as claims) with a signature and can be verified at a later time with a secret signing key.

**Tokens retrieved from authorization server API**

* **authorize endpoint** = to get consent and authorization from the user = auth grant user has consented
* **token endpoint** = processes grant returns refresh and access token

Use access token to access APIs. OAuth causes developers to managing refresh tokens ie. state management onto each client developer. You get the benefits of key rotation.  Check for language framework to help.

User's browser redirected to authorization server, user gave consent. Once the user takes that authorization grant and hands that to the application, the client application no longer needs to use the browser to complete the OAuth flow to get the tokens.

The tokens are meant to be consumed by the client application so it can access resources on your behalf. We call that the back channel. The back channel is an HTTP call directly from the client application to the resource server to exchange the authorization grant for tokens. These channels are used for different flows depending on what device capabilities you have.

### OAuth Flows

**Implicit Flow = 2 legged = browser only public clients** that doesn't support refresh tokens, assumes Resource Owner and public client on same device.

**Authorisation Code Flow = 3 legged = front and back channel**, front to get grants, back to get tokens, assumes Resource Owner and public client on different device.

**Client Credential Flow = service account scenario = confidential client application acting on own, not on behalf of user.** Only need client’s credentials to do the whole flow. Back channel only flow to obtain an access token using the client’s credentials. Supports shared secrets or assertions as client credentials signed with either symmetric or asymmetric keys.

**Symmetric-key algorithms are cryptographic algorithms that allow you to decrypt anything, as long as you have the password.** This is often found when securing PDFs or .zip files.

**Public key cryptography, or asymmetric cryptography, is any cryptographic system that uses pairs of keys: public keys and private keys.** Public keys can be read by anyone, private keys are sacred to the owner. This allows data to be secure without the need to share a password.

**Resource Owner Password Flow = legacy = not recommended (for old-school clients).**

**Assertion Flow = allows an Authorization Server to trust authorization grants from third parties such as SAML IdP.** The Authorization Server trusts the Identity Provider. The assertion is used to obtain an access token from the token endpoint. This is great for companies that have invested in SAML or SAML-related technologies and allow them to integrate with OAuth. Because SAML assertions are short-lived, there are no refresh tokens in this flow and you have to keep retrieving access tokens every time the assertion expires.

**Device Flow = no web browser, just a controller for something like a TV.** A user code is returned from an authorization request that must be redeemed by visiting a URL on a device with a browser to authorize. A back channel flow is used by the client application to poll for authorization approval for an access token and optionally a refresh token.

### Security and the Enterprise

Recommended Web Security 101 guidelines...

* Always use CSRF token with the state parameter to ensure flow integrity
* Always whitelist redirect URIs to ensure proper URI validations
* Bind the same client to authorization grants and token requests with a client ID
* For confidential clients, make sure the client secrets aren’t leaked. Don’t put a client secret in your app that’s distributed through an App Store!

The biggest complaint about OAuth in general comes from Security people. It’s regarding the Bearer tokens and that they can be passed just like session cookies. You can pass it around and you’re good to go, it’s not cryptographically bound to the user. Using JWTs helps because they can’t be tampered with. However, in the end, a JWT is just a string of characters so they can easily be copied and used in an Authorization header.

OAuth = delegated authorization = token to get access to a resource (not authentication protocol)

### Enter OpenID Connect

To solve the pseudo authentication problem, the best parts of OAuth 2.0, Facebook Connect, and SAML 2.0 were combined to create OpenID Connect. **OpenID Connect (OIDC) extends OAuth 2.0 with a new signed id_token for the client and a UserInfo endpoint to fetch user attributes.** Unlike SAML, OIDC provides a standard set of scopes and claims for identities. Examples include: profile, email, address, and phone.

OIDC was created to be internet scalable by making things completely dynamic. There’s no longer downloading metadata and federation like SAML requires. There’s built-in registration, discovery, and metadata for dynamic federations. You can type in your email address, then it dynamically discovers your OIDC provider, dynamically downloads the metadata, dynamically know what certs it’s going to use, and allows BYOI (Bring Your Own Identity). It supports high assurance levels and key SAML use cases for enterprises.

An ID token is a JSON Web Token (JWT). A JWT (aka “jot”) is much smaller than a giant XML-based SAML assertion and can be efficiently passed around between different devices. A JWT has three parts: a header, a body, and a signature. The header says what algorithm was used to sign it, the claims are in the body, and its signed in the signature.

An Open ID Connect flow involves the following steps:

1. Discover OIDC metadata
1. Perform OAuth flow to obtain id token and access token
1. Get JWT signature keys and optionally dynamically register the Client application
1. Validate JWT ID token locally based on built-in dates and signature
1. Get additional user attributes as needed with access token

#### OIDC versus OAUTH

##### Purposes

**OpenID was created for federated authentication, that is, letting a third-party authenticate your users for you, by using accounts they already have.** The term federated is critical here because the whole point of OpenID is that any provider can be used (with the exception of white-lists). You don't need to pre-choose or negotiate a deal with the providers to allow users to use any other account they have.

**OAuth was created to remove the need for users to share their passwords with third-party applications.** It actually started as a way to solve an OpenID problem: if you support OpenID on your site, you can't use HTTP Basic credentials (username and password) to provide an API because the users don't have a password on your site.

The problem is with this separation of OpenID for authentication and OAuth for authorization is that both protocols can accomplish many of the same things. They each provide a different set of features which are desired by different implementations but essentially, they are pretty interchangeable. **At their core, both protocols are an assertion verification method (OpenID is limited to the 'this is who I am' assertion, while OAuth provides an 'access token' that can be exchanged for any supported assertion via an API).**

##### Features

Both protocols provide a way for a site to redirect a user somewhere else and come back with a verifiable assertion. OpenID provides an identity assertion while OAuth is more generic in the form of an access token which can then be used to "ask the OAuth provider questions". However, they each support different features:

OpenID - the most important feature of OpenID is its discovery process. OpenID does not require hard coding each the providers you want to use ahead of time. Using discovery, the user can choose any third-party provider they want to authenticate. This discovery feature has also caused most of OpenID's problems because the way it is implemented is by using HTTP URIs as identifiers which most web users just don't get. Other features OpenID has is its support for ad-hoc client registration using a DH exchange, immediate mode for optimized end-user experience, and a way to verify assertions without making another round-trip to the provider.

OAuth - the most important feature of OAuth is the access token which provides a long lasting method of making additional requests. Unlike OpenID, OAuth does not end with authentication but provides an access token to gain access to additional resources provided by the same third-party service. However, since OAuth does not support discovery, it requires pre-selecting and hard-coding the providers you decide to use. A user visiting your site cannot use any identifier, only those pre-selected by you. Also, OAuth does not have a concept of identity so using it for login means either adding a custom parameter (as done by Twitter) or making another API call to get the currently "logged in" user.

3. Technical Implementations

The two protocols share a common architecture in using redirection to obtain user authorization. In OAuth the user authorizes access to their protected resources and in OpenID, to their identity. But that's all they share.

Each protocol has a different way of calculating a signature used to verify the authenticity of the request or response, and each has different registration requirements.
















