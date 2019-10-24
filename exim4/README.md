# exim4

The files here create a docker image containing the
[Exim4](http://www.exim.org/) MTA. With the default configuration it will act as
a local MTA accepting mail from the local host destined for any external host by
DNS.

## Environment variables

The behaviour of the MTA can be modified by passing in various environment
variables.

* LOCAL_DOMAINS - colon-separated list of domains to be delivered locally on the
  local host
* PRIMARY_HOSTNAME - hostname of th MTA. If unset exim will use uname() to work
  this out
* RELAY_FROM_HOSTS - colon-separated list of hosts to permit relaying from
* RELAY_TO_DOMAINS - colon-separated list of domains to allow relaying to
* RELAY_TO_USERS - list of addresses to allow relaying to
* SMARTHOST - remote host to smartroute all mail to
* CYRUS_DOMAIN - domain of a cyrus-imapd server to deliver to using the LMTP
  protocol

## Virtual domain configuration

The MTA supports virtual domain configuration for the routing of mail to
maildrop servers. It will look for an alias file for each local domain in the
following location:

```
$ cat /etc/exim/virtualdomains/example.com
john: john@imap.example.com
```

When routing mail for `john@example.com` the MTA will then deliver mail to
`john@imap.example.com`. For this to be useful the domains will also need to be
configured as LOCAL_DOMAINS.

You can bind-mount the files into the container with the docker `-v` option like
so:

```-v $(pwd)/example.com:/etc/exim/virtualdomains/example.com```

## Building the image

```
docker build -t stephengrier/exim4:latest .
```

## Running the container

The run a simple local MTA to relay locally generated mail out to the internet
via DNS:

```
docker run --name "mta" -d -p 25:8025 stephengrier/exim4
```

To smartroute all mail to an upstream MTA:

```
docker run --name "mta" -d -p 25:8025 \
  -e SMARTHOST=smarthost.example.com \
  stephengrier/exim4
```

To accept mail from the internet for a local mail domain to be delivered to a
local maildrop server:

```
docker run --name "mta" -d -p 25:8025 \
  -v $(pwd)/example.com:/etc/exim/virtualdomains/example.com \
  -e LOCAL_DOMAINS=example.com \
  -e RELAY_FROM_DOMAINS= \
  -e CYRUS_DOMAIN=imap.example.com \
  stephengrier/exim4
```

