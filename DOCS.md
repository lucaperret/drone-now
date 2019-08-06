---
date: 2018-01-24T00:00:00+00:00
title: Now
author: lucaperret
tags: [ deploy, now ]
repo: lucaperret/drone-now
logo: now.svg
image: lucap/drone-now
---

The Now plugin deploy your build to [now.sh](https://zeit.co/now).

The below pipeline configuration demonstrates simple usage:

Note: `deploy_name` is an optional parameter. If it is not given now.sh will use name of the working directory .

```yaml
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    now_token: keep-this-secret
```

Or use the secret NOW_TOKEN instead, if you supply both the plugin will use the `now_token` parameter first

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
-   now_token: keep-this-secret
+   secrets: [ now_token ]
```

Set the directory you want to deploy. See the [Deployment Documentation](https://zeit.co/docs/getting-started/deployment#) for more info.

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
+   directory: public
```

Example configuration with team scope:

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
-   directory: public
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

Example configuration for [Cleaning Up Old Deployments](https://zeit.co/docs/other/faq#how-do-i-remove-an-old-deployment):

Note: You must set the `alias` parameter with `cleanup`.

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
+   alias: my-deployment-alias
+   cleanup: true
```

Example configuration with custom [Path Aliases](https://zeit.co/docs/features/path-aliases):

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name
    secrets: [ now_token ]
-   alias: my-deployment-alias
-   cleanup: true
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

## Local Config

The plugin supports configuration using [local config options](https://zeit.co/docs/features/configuration) in a `now.json` file.
If you have a local config specified the local config options will take precedence over any duplicate options specified in the drone config. For example:
```
# now.json
{
  "name": "my-cool-deployment",
  "alias": "cool-deployment.now.sh",
  "type": "static"
}
```
Note that the default behavior of `now` applies. If you do not specify a `"type"`, it will try to detect based on the presence of a static directory path (set by `path:`), a package.json, or a Dockerfile. If you do not set an alias in the local config file, this plugin will not attempt to alias your deployment.

```diff
pipeline:
  now:
    image: lucap/drone-now
    deploy_name: deployment-name # The deployment will be named 'my-cool-deployment'
+   alias: my-deployment-alias # The alias will be set to 'cool-deployment.now.sh'
    secrets: [ now_token ]
    local_config: now.json
-   scale: 2
```

# Secret Reference

now_token
: Now token

# Parameter Reference

now_token
: Your API token (can also be set implicitly with a secret named NOW_TOKEN)

deploy_name
: Set the name of the deployment

directory
: The directory you want to deploy

team
: Set the team scope

type
: Deployment type (docker, npm, static)

alias
: Target now.sh subdomain or domain

cleanup
: Equivalent to `now rm --safe --yes $alias`

rules_domain
: Your domain

rules_file
: File that contain set of rules

scale
: Min and Max scaling values e.g. "scale: 0 3"

local_config:
: name of the file. The plugin assumes that the file is in the root dir
