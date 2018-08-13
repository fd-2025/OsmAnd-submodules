## OsmAnd Submodules

Repository holding [OsmAnd](https://github.com/osmandapp) releases set
up with sane submodules and tags.

### Updating

Update submodules to use commits specified in the
[last stable build of OsmAnd](http://builder.osmand.net:8080/view/OsmAnd%20Builds/job/Osmand-release/lastStableBuild/tagBuild/).

Note the OsmAnd-core directory does not correspond to the OsmAnd-core in
the Jenkins data linked above (which actually corresponds to the
core-legacy directory).  The OsmAnd-core directory is needed by the
F-Droid build to build the Java/native interface that the standard build
process usually downloads as a pre-compiled binary.  Since I do not know
how to determine the correct commit of OsmAnd-core to use for this, i
have just been updating to the latest version at the time of the OsmAnd
release.
