## About

[SNMP daemon (snmpd)](http://www.net-snmp.org/) Docker image based on Alpine Linux.<br />


## Features

* Net-SNMP 5.8 daemon patched to be able to monitor on CoreOS (use `/rootfs/{dev|etc|proc|sys}`)
* Fix [CVE-2018-18066](https://nvd.nist.gov/vuln/detail/CVE-2018-18066)
* IPv6 disabled

## Ports

* `161/udp` : snmpd UDP listen port

## Usage

warning: snmpd has been patched to use ` /rootfs/{dev|etc|proc|sys}`.

### Docker Compose

Docker compose is the recommended way to run this image. Edit the compose file with your preferences in [examples/compose](examples/compose) and run the following command :

```bash
$ docker-compose up -d
$ docker-compose logs -f
```

### Command line

You can also use the following minimal command :

```bash
$ docker run -d --name snmpd \
  --privileged \
  -p 161:161/udp \
  -v /:/rootfs:ro \
  -v /etc/localtime:/etc/localtime:ro \
  nbharadwaj/net-snmpd:0.1
```

You can also mount your own `snmpd.conf` :

```bash
$ docker run -d --name snmpd \
  --privileged \
  -p 161:161/udp \
  -v /:/rootfs:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -v $(pwd)/snmpd.conf:/etc/snmpd.conf \
  nbharadwaj/net-snmpd:0.1
```

## Notes

If you've got the following error :

```
Cannot statfs /rootfs/proc/sys/fs/binfmt_misc: Symbolic link loop
```

Restart this service :

```
systemctl restart proc-sys-fs-binfmt_misc.mount
```

## Upgrade

To upgrade, pull the newer image and launch the container :

```bash
docker-compose pull
docker-compose up -d
```

## License

MIT. See `LICENSE` for more details.
