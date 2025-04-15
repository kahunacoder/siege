# Siege, a simple and powerful tool for testing the performance of web applications

## Features

- Simulate multiple users accessing the application simultaneously
- Test the performance of web applications and APIs
- Generate detailed reports on response times, throughput, and other performance metrics
- Support for HTTP and HTTPS protocols
- Support for basic authentication and cookies
- Support for custom headers and request methods
- Support for proxy servers
- Support for SSL/TLS

### How to use this docker image

- Build the image from GitHub:

```bash
docker build --no-cache -f https://raw.githubusercontent.com/kahunacoder/siege/refs/heads/master/Dockerfile -t siege .
```

- Run the image:

```bash
docker run -it --rm siege -t30s -c10 -b -v -d1 --header="Authorization:Basic <base64-encoded-credentials>" 'https://example.com'
```

This command runs a Docker container with the `siege` tool to perform a load test on a specified URL and then removes the container after the test is complete. The command includes several options to customize the test parameters.

Options:

- `-t30s`: Specifies the duration of the test (30 seconds in this case).
- `-c10`: Sets the number of concurrent users (10 in this case).
- `-b`: Runs the test in "benchmark" mode, which disables delay between requests.
- `-v`: Enables verbose output for detailed information during the test.
- `-d1`: Sets a delay of 1 second between requests (ignored in benchmark mode).
- `--header`="Authorization:Basic <base64-encoded-credentials>"`: Adds an HTTP header for basic authentication

The URL being tested is 'https://example.com'.

Note: Replace `<base64-encoded-credentials>` with your actual base64-encoded credentials before running the command.

### How to generate base64-encoded credentials

To generate the base64-encoded credentials for basic authentication, you can use the following command:

```bash
echo -n 'user:password' | openssl base64
```

`dXNlcjpwYXNzd29yZA==` is generated for `user:password` using the above command.

```bash
docker run -it --rm siege -t30s -c10 -b -v -d1 --header="Authorization:Basic dXNlcjpwYXNzd29yZA==" 'https://example.com'
```

```bash
Lifting the server siege...
Transactions:                 526    hits
Availability:                 100.00 %
Elapsed time:                  31.00 secs
Data transferred:              52.64 MB
Response time:                481.96 ms
Transaction rate:              16.97 trans/sec
Throughput:                     1.70 MB/sec
Concurrency:                    8.18
Successful transactions:      526
Failed transactions:            0
Longest transaction:         3150.00 ms
Shortest transaction:         210.00 ms
```

#### Credits

<https://github.com/JoeDog/siege>
<https://www.joedog.org/siege-home/>
