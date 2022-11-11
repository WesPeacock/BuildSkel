# Build Skeleton
This repo contains a script to build two skeleton fields for each SFM record. One skeleton field contains a list of all of the SMFs and the other contains some of the SFMs.

## Running the script

Edit the .**INI** file to say which SFMs are to be in the partial SFM skeleton field. A model **.INI** file, **BuildSkel.ini** is included with the repo and is explained below.

If you use WSL, make sure the script has Linux line endings. The script will correctly read SFM and .INI files that have Windows line endings. The output file will contain Linux line endings.

It's easiest to copy the script, your **.INI** file, and your SFM file into a working directory and navigate to that. The instructions below assume that they are in the current directory.

Run the script with default arguments:

````bash
./BuildSkel.pl InputSFM.db >OutputSFM.db
````

To see the possible arguments use the **--help** option:

````bash
$ ./BuildSkel.pl --help
Usage: ./BuildSkel.pl [--inifile inifile.ini] [--section section] [--recmark lx] [--eolrep #] [--reptag __hash__] [--debug] [file.sfm]
A script that builds skeleton fields for each SFM record. One skeleton field contains a list of all of the SMFs and the other contains some of the SFMs.
````
