#!/bin/bash
set -e

echo "Welcome to edhurtig's Chef Server Installation Script."
echo "Please change the following options or accept the defaults by just hitting enter"

PACKAGE_URL_BASE="https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/"
read -i "$PACKAGE_URL_BASE" -p "Chef Server Package Download Location (base path): " PACKAGE_URL_BASE

PACKAGE_NAME="chef-server-core_12.0.8-1_amd64.deb"
read -i "$PACKAGE_NAME" -p "Chef Package name (filename): " PACKAGE_NAME

USERNAME="vagrant"
read -i "$USERNAME" -p "Chef Admin Username: " USERNAME


FIRSTNAME="ashwini"
read -i "$FIRSTNAME" -p "Chef Admin First Name: " FIRSTNAME

LASTNAME="chaudhari"
read -i "$LASTNAME" -p "Chef Last Name: " LASTNAME


echo -n "Admin Password (Will be hidden):"
read -s PASSWORD
echo


EMAIL="ashwinic@kumolus.com"
read -i "$EMAIL" -p "Chef Email: " EMAIL

KEY_PATH="/home/$USERNAME/$USERNAME.pem"
read -i "$KEY_PATH" -p "Save User's Key To: " KEY_PATH


ORG_SHORT="vagrantorg"
read -i "$ORG_SHORT" -p "Org Short Name: " ORG_SHORT


ORG_LONG="vagrant Technologies"
read -i "$ORG_LONG" -p "Org Long Name: " ORG_LONG


VALIDATOR_PATH="/home/$USERNAME/$ORG_SHORT-validator.pem"
read -i "$VALIDATOR_PATH" -p "Save Validator Key To: " VALIDATOR_PATH

echo '###########################################'
echo '#     OK THANKS! DOING THE INSTALL...     #'
echo '###########################################'

mkdir /tmp/chef-server-install

cd /tmp/chef-server-install


wget "$PACKAGE_URL_BASE$PACKAGE_NAME"

dpkg -i "$PACKAGE_NAME"

chef-server-ctl reconfigure

echo "Waiting a brief moment"
sleep 3

echo "Creating User $USERNAME"
chef-server-ctl user-create $USERNAME $FIRSTNAME $LASTNAME $EMAIL $PASSWORD --filename $KEY_PATH

echo "Creating Org $ORG_SHORT"
chef-server-ctl org-create $ORG_SHORT $ORG_LONG --association_user $USERNAME --filename $VALIDATOR_PATH

echo "Chef Server Install Complete"
