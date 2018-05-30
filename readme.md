This is a simple project to test the interaction between træfik and a OAuth2 server (https://github.com/RichardKnop/go-oauth2-server).

# Goal

Test some configuration and try to interact with an OAuth server

# OAuth Flows

## Start the Stack

Launch the docker compose from the project root
```bash
docker-compose up -d
```

## Authorization Code Flow

* Allow the action and get the associated code
```
# Go to the following URL.
# The return code is associated to the redirect URI, so you will obtain a token only for this redirect uri.
http://localhost/web/authorize?client_id=test_client_1&redirect_uri=https%3A%2F%2Flocalhost/whoami&response_type=code&state=somestate&scope=read_write
```
Example of result:
```
https://localhost/whoami?code=e3b83d29-e55e-4f63-9519-0efce7765692&state=somestate
```
* Get the authentication token
```bash
# Replace the code value by the one fetch from the previous step
curl -L -k --post302 --compressed -v localhost/v1/oauth/tokens \
    -u test_client_1:test_secret \
    -d "grant_type=authorization_code" \
    -d "code=35464b33-f364-4ef0-8563-63bce8d15f0f" \
    -d "redirect_uri=https://localhost/whoami"

```
Example of result:
```json
{
    "user_id":"f78817d8-be19-4bb8-bbcf-0ca6fe3da010",
    "access_token":"2f6ccb51-7a28-4564-b136-b088c9bef470",
    "expires_in":3600,
    "token_type":"Bearer",
    "scope":"read_write",
    "refresh_token":"47cbcb4c-ddf5-4d74-9c19-39dba22c35e9"
}

```

## Implicit Flow

* Get the token from the first call
```
# Go to the following URL.
http://localhost/web/authorize?client_id=test_client_1&redirect_uri=https%3A%2F%2Flocalhost/whoami&response_type=token&state=somestate&scope=read_write
```  
Example of result:
```
https://localhost/whoami#access_token=0125988f-aa50-44b6-ab55-5ff74d9e1313&expires_in=3600&scope=read_write&state=somestate&token_type=Bearer
```
## Resource Owner Password Credentials

```bash
curl -L -k --post302 --compressed -v localhost/v1/oauth/tokens \
	-u test_client_1:test_secret \
	-d "grant_type=password" \
	-d "username=jb@contain.us" \
	-d "password=password" \
	-d "scope=read_write"
```

## Check the token

```json
{
  "user_id":"f78817d8-be19-4bb8-bbcf-0ca6fe3da010",
  "access_token":"a775b95b-1aad-4808-b80d-a285aaadc59f",
  "expires_in":3600,
  "token_type":"Bearer",
  "scope":"read_write",
  "refresh_token":"47cbcb4c-ddf5-4d74-9c19-39dba22c35e9"}
```

```bash
curl -L -k --post302 --compressed -v localhost/v1/oauth/introspect \
	-u test_client_1:test_secret \
	-d "token=a775b95b-1aad-4808-b80d-a285aaadc59f" \
	-d "token_type_hint=access_token"
```