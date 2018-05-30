This is a simple project to test the interaction between træfik and a OAuth2 server.

# Goal


# Use case

Launch the docker compose
```bash
docker-compose up
```

## Authorization Code

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
    -d "code=b6191b52-1eeb-40f0-81f8-574ab1c3f81d" \
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

## Implicit

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
curl -L -k --post302 --compressed -v -X POST localhost/v1/oauth/userinfo \
    -H "Authorization: Bearer a775b95b-1aad-4808-b80d-a285aaadc59f"

```

curl -L -k --post302 --compressed -v localhost/v1/oauth/introspect \
	-u test_client_1:test_secret \
	-d "token=b59d2bc4-1fd6-43b4-b72f-b6172446ee34" \
	-d "token_type_hint=access_token"

# References

* OAuth server: https://github.com/RichardKnop/go-oauth2-server
