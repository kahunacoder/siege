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

More Info

- <https://github.com/JoeDog/siege>
- <https://www.joedog.org/siege-home/>

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

### Using the siege.conf file

By mounting a local directory to the container, you can customize the siege.conf file to suit your needs.

```bash
docker run -v /your/local/directory:/root -it --rm siege
```

This command mounts the local directory `/your/local/directory` to the container's `/root` directory. You can then edit the default siege.conf file in `/your/local/directory/.siege/seige.conf`, and it will be used by the siege tool when you run it.

The siege.conf file is a configuration file for the siege tool. It allows you to customize various settings and options for your siege tests.

The login option in the siege.conf file is used to specify the credentials for basic authentication. The format is `user:password:realm`, where `user` is the username, `password` is the password, and `realm` is the authentication realm. This option allows you to perform authenticated requests during your siege tests. The realm value is optional but is useful if you run seige on multiple sites. To get the realm value, you can use the `curl` command with the `-i` option to see the headers returned by the server. The realm value is usually included in the `WWW-Authenticate` header. For example:

```bash
curl -i https://example.com
```

This command will return the headers, and you can look for the `WWW-Authenticate` header to find the realm value.

These are the changes I made to my siege.conf from the default siege.conf file:

```conf
# siege.conf
logfile = $(HOME)/siege.log
show-logfile = false
logging = true
parser = false
file = $HOME/urls.txt
login = user:password:realm
```

I also created a `/your/local/directory/urls.txt` file. The urls.txt file contains the URLs that you want to test with siege. Each URL should be on a separate line.

You can view the siege log in `/your/local/directory/siege.log` file. The siege.log file contains detailed information about the siege test, including the number of transactions, response times, and other performance metrics.

With this setup you can run this command to run the siege test:

```bash
docker run -v /your/local/directory:/root -it --rm siege --reps=once -c1 -d1 -m "a note for the log file"
```

- `--reps=once`: This is a siege option that specifies the number of repetitions for the test. once means the test will run a single time. For some reason this option is broken when used with the `urls.txt` file.
- `-c1`: This siege option sets the number of concurrent users to 1. It simulates a single user making requests to the server.
- `-d1`: This option sets the delay between requests to 1 second. It controls the pacing of the load test.
- `-m` "a note for the log file": This option adds a custom message ("a note for the log file") to the log file generated by siege. It can be useful for annotating the purpose or context of the test.

