# Nginx-rate-limiting-example

This is an testable example for Ngnix rate limiting module.

It can be used to limit the rate of the requests at either the location/ http/ server/.

## Build & Run:

To build the image:

    docker build -t drew-mobilise/nginx-rate-limit-example .

To run the image in the background:

    docker run -d --rm -p 80:80 drew-mobilise/nginx-rate-limit-example

To exec onto the running container and alter the nginx config values for different testing scenario:

    # Get container Id of the running container because we need that
    docker ps
    # Exec on to running image
    docker exec -it <CONTAINER_ID> /bin/bash
## Endpoints:

- http://127.0.0.1:80/by-uri/no_limit
- http://127.0.0.1:80/by-uri/nginx-burst0
- http://127.0.0.1:80/by-uri/nginx-burst0_nodelay
- http://127.0.0.1:80/by-uri/nginx-burst
- http://127.0.0.1:80/by-uri/nginx-burst_nodelay
- http://127.0.0.1:80/by-uri/nginx-burst_delay_defined
- http://127.0.0.1:80/by-uri/nginx-burst_different_error_code
- http://127.0.0.1:80/by-uri/nginx-burst_log_level

## Testing: