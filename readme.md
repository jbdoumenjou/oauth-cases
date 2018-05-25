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
# The return code is associated to the redirect URI, so you will obtain a token only for this redirect uri.
GET http://localhost/web/authorize?client_id=test_client_1&redirect_uri=https%3A%2F%2Flocalhost/whoami&response_type=code&state=somestate&scope=read_write
```

* Get the authentication token
```bash
# Replace the code value by the one fetch from the previous step
curl -L -k --post302 --compressed -v localhost/v1/oauth/tokens \
    -u test_client_1:test_secret \
    -d "grant_type=authorization_code" \
    -d "code=368edfbd-0d4a-436a-8775-372ec54d52d4" \
    -d "redirect_uri=https://localhost/whoami"
```

## Implicit

* 
http://localhost/web/authorize?client_id=test_client_1&redirect_uri=https%3A%2F%2Flocalhost/whoami&response_type=token&state=somestate&scope=read_write
