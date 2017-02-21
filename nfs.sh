#!/bin/bash
source /tmp/netapp_variables
if [ -f /etc/debian_version ]; then apt-get update
     if [ "$NETAPP_PROTOCOL_CIFS" == "cifs" ] && [ "$NETAPP_NO_VOLUME_CIFS" -gt "0" ]; then apt-get install -y cifs-utils
         for (( i=0; i<$NETAPP_NO_VOLUME_CIFS; i++ ))
         do
             if [ -d ${NETAPP_MOUNTC_CIFS[$i]} ]; then 
                mount.cifs //$NETAPP_MOUNT_IP/${NETAPP_SHARE_MOUNT_CIFS[$i]} ${NETAPP_MOUNTC_CIFS[$i]} -o username=$NETAPP_CIFS_USERNAME,password=$NETAPP_CIFS_PASSWORD
             else
                 mkdir -p ${NETAPP_MOUNTC_CIFS[$i]}
                 mount.cifs //$NETAPP_MOUNT_IP/${NETAPP_SHARE_MOUNT_CIFS[$i]} ${NETAPP_MOUNTC_CIFS[$i]} -o username=$NETAPP_CIFS_USERNAME,password=$NETAPP_CIFS_PASSWORD
            fi
        done
     fi
    if [ "$NETAPP_PROTOCOL_NFS" == "nfs" ] && [ "$NETAPP_NO_VOLUME_NFS" -gt "0" ]; then apt-get install -y nfs-common
          for (( i=0; i<$NETAPP_NO_VOLUME_NFS; i++ ))
          do
              if [ -d ${NETAPP_MOUNTC_NFS[$i]} ]; then 
                  mount -t $NETAPP_PROTOCOL_NFS ${NETAPP_MOUNT_IP}:${NETAPP_MOUNTS_NFS[$i]} ${NETAPP_MOUNTC_NFS[$i]}
              else
                  mkdir -p ${NETAPP_MOUNTC_NFS[$i]}
                  mount -t $NETAPP_PROTOCOL_NFS ${NETAPP_MOUNT_IP}:${NETAPP_MOUNTS_NFS[$i]} ${NETAPP_MOUNTC_NFS[$i]}
              fi
          done
    fi   
fi
