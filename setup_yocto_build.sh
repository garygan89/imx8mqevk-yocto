# Usage
# setup_build.sh -b <yocto_branch> -f <manifest_xml>
#!/bin/bash
ROOT_DIR=`pwd`
REPO_BIN_DIR=$ROOT_DIR/bin
YOCTO_BSP_DIR=$ROOT_DIR/imx-yocto-bsp
MANIFEST_REPO_URL="https://github.com/garygan89/imx8-manifest"

NUM_THREADS=8

DEFAULT_YOCTO_BRANCH="imx-linux-sumo"
DEFAULT_MANIFEST_XML="imx-4.14.98-2.0.0_ga-virt.xml"

mkdir $REPO_BIN_DIR
curl https://storage.googleapis.com/git-repo-downloads/repo > $REPO_BIN_DIR/repo
chmod a+x $REPO_BIN_DIR/repo
export PATH=$REPO_BIN_DIR:$PATH

usage() {
	echo ""
	echo "Usage: $0 -b yoctoversion -f repoxmlmanifest"
	echo -e "\t-b sumo, rocko, thud"
	echo -e "\t-f 4.14.xml"
	echo -e "\t-j number of threads to sync repo"
	exit 1
}

# init repo, if no repo is specified, use default
while getopts "b:f:j:" opt
do
	case "$opt" in
		b ) YOCTO_BRANCH="$OPTARG" ;;
		f ) REPO_XML="$OPTARG" ;;
		j ) NUM_THREADS=$OPTARG ;;
		? ) usage ;;
	esac
done

if [ -z "$YOCTO_BRANCH" ]
	then
		YOCTO_BRANCH=$DEFAULT_YOCTO_BRANCH
fi

if [ -z "$REPO_XML" ]
	then
		REPO_XML=$DEFAULT_MANIFEST_XML
fi

# print the yocto branch and repo xml chosen
echo "Syncing repo using yocto branch=$YOCTO_BRANCH, repoxml=$REPO_XML, numthreads=$NUM_THREADS"
mkdir -p $YOCTO_BSP_DIR
cd $YOCTO_BSP_DIR
# make sure to use Python2 instead of Python3 to avoid error, on Debian, use update-alternatives to change the python symlnk globally instead of hard code modify the symlink in /usr/bin
repo init -u $MANIFEST_REPO_URL -b $YOCTO_BRANCH -m $REPO_XML
repo sync -j$NUM_THREADS

# initialize the bitbake build dir
DISTRO=fsl-imx-xwayland MACHINE=imx8mqevk source fsl-setup-release.sh -b build

# copy the bitbake conf that we customized, currently we just append additional package to the already existing recipe 'fsl-image-validation-imx`. We should create our own image recipe at some point later.
echo "Copying customized recipe on top of 'fsl-image-validation-imx' recipe."
cp bitbake/local.conf $YOCTO_BSP_DIR/build/conf/local.conf
cp bitbake/bblayers.conf $YOCTO_BSP_DIR/build/conf/bblayers.conf

echo "Yocto build system configuration completed! To start using bitbake command, source the environment"
echo "\tsource setup-environment"

echo "You may then use the following to build the image."
echo "\tbitbake fsl-image-validation-imx"
echo ""
echo "The final sdcard image is located at 'build/bitbake/tmp/deploy/images/fsl-image-validation-imx/'
