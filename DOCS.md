---
date: 2018-01-24T00:00:00+00:00
title: Now
author: lucaperret
tags: [ deploy, now ]
repo: lucaperret/drone-now
logo: now.svg
image: lucap/drone-now
---

The Now plugin deploy your build to [now.sh](https://zeit.co/now). The below pipeline configuration demonstrates simple usage:

```yaml
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
```

Example configuration with team scope:

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
+   team: myteam
```

Example configuration to enforce type (by default, it's detected automatically):

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
-   team: myteam
+   type: npm
```

Example configuration for assigning [Aliases and Domains](https://zeit.co/docs/features/aliases):

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
-   type: npm
+   alias: my-deployment-alias
```

Example configuration with custom [Path Aliases](https://zeit.co/docs/features/path-aliases):

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
+   rules_domain: example.com
+   rules_file: rules.json
```

Example configuration for [Scaling](https://zeit.co/docs/getting-started/scaling):

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
-   rules_domain: example.com
-   rules_file: rules.json
+   scale: 2
```


# Secret Reference

now_token
: Now token

# Parameter Reference

deploy_name
: Set the name of the deployment

team
: Set the team scope

type
: Deployment type (docker, npm, static)

alias
: Target Now.sh subdomain or domain

rules_domain
: Your domain

rules_file
: File that contain set of rules

scale
: Min and Max scaling values