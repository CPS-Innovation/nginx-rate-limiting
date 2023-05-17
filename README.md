# Nginx-rate-limiting-example

This is an testable example for Ngnix rate limiting module.

It can be used to limit the rate of the requests at either the location/ http/ server/ for either URI or IP address.

For more info on the break down of the ngx_http_limit_req_module see:

https://nginx.org/en/docs/http/ngx_http_limit_req_module.html

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

## Nginx Config breakdown

Below is break down of the various limit-req functions that you can use inside of location blocks.

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /by-uri/no_limit {
	    try_files $uri /index.html;
    }

    location /by-uri/nginx-burst0 {
        limit_req zone=by_uri;
        # uses just the set rate from limit_req_zone, leaky bucket algorithm, anything above that number is rejected.
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst0_nodelay {
        limit_req zone=by_uri nodelay;
        # removes the delay function so all requests are processed straight away.
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst {
        limit_req zone=by_uri burst=10;
        # adds a burst mode on top the the request limit making it a token algorithm of X + 10
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst_nodelay {
        limit_req zone=by_uri burst=10 nodelay;
        # adds a burst mode on top the the request limit making it a token algorithm of X + 10 but removes the delay.
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst_delay_defined {
        limit_req zone=by_uri burst=10 delay=20;
        # changes the delay to be a set number of requests, by default it is delay everything.
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst_different_error_code {
        limit_req zone=by_uri burst=10;
        limit_req_status 429;
        # changes the error code from the default 509 to be a different error code to suit an applications logic.
        try_files $uri /index.html;
    }

    location /by-uri/nginx-burst_log_level {
        limit_req zone=by_uri burst=10;
        limit_req_log_level warn;
        # changes the log output from info default to warn, can also be error or notice.
        try_files $uri /index.html;
    }

## Endpoints:

These are the following endpoints you can hit once the image is running locally.

- http://127.0.0.1:80/by-uri/no_limit
- http://127.0.0.1:80/by-uri/nginx-burst0
- http://127.0.0.1:80/by-uri/nginx-burst0_nodelay
- http://127.0.0.1:80/by-uri/nginx-burst
- http://127.0.0.1:80/by-uri/nginx-burst_nodelay
- http://127.0.0.1:80/by-uri/nginx-burst_delay_defined
- http://127.0.0.1:80/by-uri/nginx-burst_different_error_code
- http://127.0.0.1:80/by-uri/nginx-burst_log_level

## Testing:

To test the various functionality of each limit_req we can use a tool called Siege (https://www.joedog.org/siege-home/) to hit the various
endpoints to see how they work.

    siege -b -r 1 -c20 http://127.0.0.1:80/by-uri/<last_part_of_uri>

This will send 20 concurrent requests to the endpoint.