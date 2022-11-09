# Build Skeleton
This repo contains a script to build a skeleton field for each SFM record. A skeleton field contains a list of all or some of the SFMs in the record.

## Running the script

Edit the .**INI** file to say which SFMs are used to mark records and fields that can contain homographs. A model **.INI** file, **BuildSkel.ini** is included with the repo and is explained below.

If you use WSL, make sure the script has Linux line endings. The script will correctly read SFM and .INI files that have Windows line endings. The output file will contain Linux line endings.

It's easiest to copy the script, your **.INI** file, and your SFM file into a working directory and navigate to that. The instructions below assume that they are in the current directory.

Run the script with default arguments:

````bash
./BuildSkel.pl InputSFM.db >OutputSFM.db
````

To see the possible arguments use the **--help** option:

````bash
$ ./BuildSkel.pl --help
Usage: ./BuildSkel.pl [--inifile BuildSkel.ini] [--section section] [--logfile BuildSkel.log] [--errfile BuildSkel.err] [--debug] [file.sfm]
A script that builds a skeleton field for each SFM record. A skeleton field contains a list of all or some of the SFMs in the record..
````
