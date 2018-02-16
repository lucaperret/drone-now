# Drone-now

![Now logo](now.png?raw=true "now.sh")

> Deploying to [▲ZEIT now](https://zeit.co/now) with [Drone](https://drone.io) CI.

[![Docker Pulls](https://img.shields.io/docker/pulls/lucap/drone-now.svg)](https://hub.docker.com/r/lucap/drone-now/)
[![Image](https://images.microbadger.com/badges/image/lucap/drone-now.svg)](https://microbadger.com/images/lucap/drone-now "Get your own image badge on microbadger.com")
[![GitHub release](https://img.shields.io/github/release/lucaperret/drone-now.svg)](https://github.com/lucaperret/drone-now/releases/latest)

Use case examples:

- Automatically create staging deployments for pull requests
- Automatically deploy and alias upon pushes to master

## Usage

For the usage information and a listing of the available options please take a look at [the docs](DOCS.md).

There are two ways to deploy.

### From docker

Deploy the working directory to now.

```bash
docker run --rm \
  -e PLUGIN_TOKEN=xxxxx \
  -e PLUGIN_ALIAS=my-deployment-alias.now.sh \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  lucap/drone-now
```

### From Drone CI

```yaml
pipeline:
  now:
    image: lucap/drone-now
    token: xxxxx
    alias: my-deployment-alias.now.sh
```
