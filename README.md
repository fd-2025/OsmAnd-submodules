# OsmAnd Submodules

Repository holding [OsmAnd][1] releases set up with sane submodules and tags.

## Contents

* Submodules used to build OsmAnd.
* `prebuild.sh` -- the prebuild script for the F-Droid build.
* `build.sh` -- the build script for the F-Droid build.
* `stubs` -- source code files used to stub parts of the OsmAnd code when the upstream code uses non-free libraries that are not easily removed.

## Updating

Update submodules to use commits specified in the [last stable build of OsmAnd][2].

Note: the builder was relocated in July 2023, so build numbers were reset.

## Notes

1. The `OsmAnd-core` directory is needed by F-Droid to build the Java/native interface, which is downloaded as a pre-compiled binary in the upstream build process. To determine the correct commit of `OsmAnd-core`, check the build time of the [last stable build of OsmAnd][2] and select the commit from the most recent `OsmAnd-core` build that occurred just before that time.  
If a release revision was used in the stable build, refer to:  
https://creator.osmand.net:8080/view/all/job/OsmAndCore-android-ndk23-release/  
If the master revision was used in the stable build, refer to:  
https://creator.osmand.net:8080/view/all/job/OsmAndCore-android-ndk23/

3. To determine the correct commit of `MPAndroidChart`, check the build time of the [last stable build of OsmAnd][2] and select the `MPAndroidChart` commit that occurred just before that time.  
If a release revision was used in the stable build, refer to:  
https://creator.osmand.net:8080/view/all/job/OsmAnd-android-lib-release/  
If the master revision was used in the stable build, refer to:  
https://creator.osmand.net:8080/view/all/job/OsmAnd-android-lib/  

4. The `icu-release-50-2-1-patched-mirror` directory is not specified in the Jenkins and is a replacement for the pre-built `icu4j-49_1_patched.jar` file distributed with the OsmAnd source.

5. This process ensures that you are using the exact dependency versions that correspond to the official stable OsmAnd build.

6. The changelog text can be found here:  
https://github.com/osmandapp/OsmAnd/blob/master/OsmAnd/res/values/strings.xml  
The relevant string is the one whose name attribute starts with `release_` and ends with the corresponding version number. Changelog texts in other languages can be found in the respective `values-*` folders.

[1]: https://github.com/osmandapp
[2]: https://creator.osmand.net:8080/view/OsmAnd%20Builds/job/Osmand-release/
[3]: https://github.com/osmandapp/OsmAnd-core/commits/master

## Runner Notes

When submitting updated metadata to F-Droid, they usually want to see a successful run of the build on a GitLab runner. Information is available [here][4] on how to set up your own runner.

I found a couple of tweaks were necessary to build OsmAnd.

First, to start/create the runner, the `--cap-add` flag needed it's arguments splitting. I also needed to adjust the `-v` options to get a longer log limit via a config file (i think, see below). I.e.

    docker run -d --name gitlab-runner --restart always \
        -v /etc/gitlab-runner:/etc/gitlab-runner \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --security-opt label=disable \
        --security-opt seccomp=unconfined \
        --cap-add=NET_ADMIN --cap-add=NET_RAW \
        gitlab/gitlab-runner:alpine

Second, the default allowed running time on GitLab is 1 hour, which might not be enough. You can change the allowed time using the intructions [here][5].

Finally, a lot of log output is produced. This gets cut off after 4mb, making problems impossible to debug. In theory, you can extend this with the `--output-limit` flag or by setting `output_limit` in your runner's `config.toml`. I don't think i've reliably figured out how to do this, but currently i'm thinking that naming the runner and using a setting in `/etc/gitlab-runner/config.toml` is the way to go. In particular, register the runner with

    GITLAB_REGISTERATION_TOKEN=<token>

    docker exec gitlab-runner gitlab-runner register \
       --config /etc/gitlab-runner/config.toml \
       --url https://gitlab.com/ \
       --name myrunnername \
       --output-limit 100000 \
       --executor docker \
       --docker-image registry.gitlab.com/fdroid/ci-images-client \
       --non-interactive \
       --registration-token ${GITLAB_REGISTERATION_TOKEN}

And inside `config.toml` you want

    [[runners]]
      name = "myrunnername"
      output_limit = 100000
      ...

I don't recall creating or populating `config.toml`. Information about it is [here][6].

You will need plenty of free disk space (about 75 GB) for the runner to complete, if you are building all flavours (the `fat` build). If you are only building a single flavour (for example `arm64`), the required disk space is much lower, around 28 GB should be sufficient.

## Local Build

Using the running to test builds is painful as it runs from clean each time and prevents you inspecting the filesystem afterwards. Building locally can also be difficult due to environment constraints (e.g. Arch Linux has too recent a g++ version, and setting up an alternative needs chroot).

See the `docker` directory for a Docker environment where the build can run, to make the build process easier.

[4]: https://gitlab.com/fdroid/wiki/-/wikis/Continuous-Integration-(CI)/Running-self-hosted-GitLab-CI-Runner
[5]: https://docs.gitlab.com/ee/ci/runners/configure_runners.html
[6]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html
