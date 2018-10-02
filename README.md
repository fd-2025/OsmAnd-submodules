## OsmAnd Submodules

Repository holding [OsmAnd][1] releases set up with sane submodules and tags.

### Updating

Update submodules to use commits specified in the [last stable build of OsmAnd][2].

### Notes

1. Note the OsmAnd-core directory does not correspond to the OsmAnd-core in the
Jenkins data linked above (which actually corresponds to the core-legacy
directory).
2. The OsmAnd-core directory is needed by F-Droid to build the Java/native
interface that the standard build process usually downloads as a pre-compiled
binary. Since we do not know how to determine the correct commit of OsmAnd-core
to use for this, we have just been updating to the latest version of the
[*master* branch][3] at the time of the OsmAnd release.

[1]: https://github.com/osmandapp
[2]: https://builder.osmand.net:8080/view/OsmAnd%20Builds/job/Osmand-release/lastStableBuild/tagBuild/
[3]: https://github.com/osmandapp/OsmAnd-core/commits/master
