#!/bin/sh
##
## Replace customized EA4 Global php.ini with the original distributed copy.
##

PHPVER="php56"; # Declare PHP version here.
INI_FILE="/opt/cpanel/ea-$PHPVER/root/etc/php.ini"; # Shouldn't be changed unless EA4 PHP version is installed in a custom location (Rare.)
RPM=$(rpm -qf $INI_FILE); # Confirms the RPM name that provides the php.ini file.
CPTECH='/root/cptechs'; # Work directory, change if you prefer a different location. (No trailing slash.)

if [ ! -d "$CPTECH" ]; then mkdir -p "$CPTECH"; fi # Create work directory if it doesn't exist.

if [ ! -f /usr/bin/yumdownloader ]; then echo "Yum utils not found. Please install yum-utils and try again."; fi # Check for yum-downloader tool from yum-utils.

/usr/bin/yumdownloader --destdir="$CPTECH" "$RPM"; # Use yum-downloader to download the ea-php##-common RPM for extracting the original php.ini file.
cd $CPTECH; # Move to the working directory defined.
rpm2cpio $RPM.rpm | cpio -idmv; # Extract the RPM in the work directory.

NEW_PHP_INI=$(find "$CPTECH" -type f -name 'php.ini'); # Declare the new/source php.ini file path.

mv -v $INI_FILE{,.bak}; # Move the original (customized) php.ini file to php.ini.bak.
cp -av $NEW_PHP_INI $INI_FILE; # Copy the new/source php.ini to it's original location defined in $INI_FILE.
diff -u $INI_FILE.bak $INI_FILE; # Print output showing the differences from the source and customized version.
