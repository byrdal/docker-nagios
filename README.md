# Nagios in docker

Nagios running in docker

- Nagios Core 4.5.10
- Nagios Plugins 2.4.12
- Nagiosgraph 1.5.2
- Check Mysql Health 2.2.2

## Running the image

```
docker run --name nagios -p 80:80 byrdal/nagios:latest
```

Access the web interface at http://localhost:80

## Credentials

Set basic auth credentials for the web interface as environment variables `NAGIOS_USER` & `NAGIOS_PASS`, default
credentials are `nagiosadmin` / `nagiosadmin`

## Configuration

Nagios configuration lives in `/usr/local/nagios/etc` and objects are in `/usr/local/nagios/etc/objects`.
The image comes with sample configuration, to customize the configuration volume mount your own configuration. 

## Volumes

Configuration objects: `/usr/local/nagios/etc/objects`

Scripts: `/usr/local/nagios/scripts`

Status files: `/usr/local/nagios/var`

Nagiosgraph status: `/usr/local/nagiosgraph/var` 

## Environment variables

- `NAGIOS_BASIC_AUTH` Enable or disable nagios web basic auth (default: enabled)
- `NAGIOS_USER` Username for nagios web basic auth (default: nagiosadmin)
- `NAGIOS_PASS` Password for nagios web basic auth (default: nagiosadmin)
- `NAGIOS_TIMEZONE` Timezone for web (default: UTC)  
- `NAGIOS_DATE_FORMAT` Date format (default: iso8601)
- `NAGIOS_THEME` Theme for web interface, possible values "dark" or "light" (default: dark)
