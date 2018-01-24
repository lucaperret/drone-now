# drone-now

[![Docker Pulls](https://img.shields.io/docker/pulls/lucap/drone-now.svg)](https://hub.docker.com/r/lucap/drone-now/)
[![](https://images.microbadger.com/badges/image/lucap/drone-now.svg)](https://microbadger.com/images/lucap/drone-now "Get your own image badge on microbadger.com")
[![Release](https://github-release-version.herokuapp.com/github/lucaperret/drone-now/release.svg?style=flat)](https://github.com/lucaperret/drone-now/releases/latest)

Deploying to [now.sh](https://zeit.co/now) with [Drone](https://drone.io) CI. For the usage information and a listing of the available options please take a look at [the docs](DOCS.md).

## Usage

There are two ways to deploy.

* [usage from docker](#usage-from-docker)
* [usage from drone CI](#usage-from-drone-ci)

### Usage from docker

Deploy the working directory to now.

```bash
docker run --rm \
  -e NOW_TOKEN=xxxxxxx \
  -e NOW_ALIAS=my-deployment-alias.now.sh \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  lucap/drone-now
```

### Usage from Drone CI

```yaml
pipeline:
  now:
    image: lucap/drone-now
    token: xxxxx
    name: deployment-name
```
