


## Docker 
### Failed to solve checksum
=> File not found ( the good fils is /docker/backend/Dockerfile)
```
    => ERROR [development 8/9] COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh                                                                                              0.0s
    ------
    > [development 8/9] COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh:
    ------
    Dockerfile:27
    --------------------
    25 |         && chmod -R 775 storage bootstrap/cache
    26 |     
    27 | >>> COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
    28 |     RUN chmod +x /usr/local/bin/entrypoint.sh
    29 |     
    --------------------
    ERROR: failed to build: failed to solve: failed to compute cache key: failed to calculate checksum of ref imrfq3impgb5qvwqtp1b9hxzt::k7tdkd7ai7210wubfc8gcxodz: "/docker/entrypoint.sh": not found
```

