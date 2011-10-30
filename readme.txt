This is Axis Data Management's modern build of the 'relames'
RelaxNG+Schematron-capable validator from Sun's MSV project.
This project, https://github.com/unsaved/relames, is an indirect fork of the
'relames' portion of the much more comprehensive project
https://github.com/kohsuke/msv>

For information about the purpose and use of the relames product, please see
https://github.com/unsaved/relames/blob/master/doc/README.txt

We use Gradle instead of Ant or Maven to build jars, zips, and Maven
repository artifacts, and includes Gradle's "wrapper" infrastructure so that
all you need to build is a Java SDK.

The upstream relames component has been aborted by Sun, as shown by the
contents of the readme file for the component at
https://github.com/kohsuke/msv/blob/master/relames/readme.txt :

    This directory is nonfunctional.


COPYRIGHT DETAILS:

The parts of this relames distribution that come from Sun are licensed by
Sun's new, open source license for the MSV project of which 'relames' is an
obsoleted part.  See file

    https://github.com/unsaved/relames/blob/master/doc/copyright.txt

The zip distribution of this project includes open source third party libraries
which are unmodified binary redistributions, so you should seek licensing
information within those individual jar files.

The remaining resources of this project, i.e. those parts which are not third
party jar files nor resources create by Sun, are hereby licensed by
Apache 2.0.  See file

    https://github.com/unsaved/relames/blob/master/doc/Apache-LICENSE-2.0.txt
