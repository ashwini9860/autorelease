#!/bin/bash
source /tmp/netapp_variables
if [ -f /etc/debian_version ]; then
     apt-get update
     if [ "$NETAPP_PROTOCOL_CIFS" == "cifs" ] && [ "$NETAPP_NO_VOLUME_CIFS" -gt "0" ]; then
         apt-get install -y cifs-utils #installation of nfs protocol
         for (( i=0; i<$NETAPP_NO_VOLUME_CIFS; i++ ))
         do
            if [ -d ${NETAPP_MOUNTC_CIFS[$i]} ]; then 
             	 echo "//$NETAPP_MOUNT_IP/${NETAPP_SHARE_MOUNT_CIFS[$i]}  ${NETAPP_MOUNTC_CIFS[$i]} $NETAPP_PROTOCOL_CIFS rw,nouser,username=$NETAPP_CIFS_USERNAME,password=$NETAPP_CIFS_PASSWORD 0 0" >> /etc/fstab 
            else
               mkdir -p ${NETAPP_MOUNTC_CIFS[$i]}
               echo "//$NETAPP_MOUNT_IP/${NETAPP_SHARE_MOUNT_CIFS[$i]}  ${NETAPP_MOUNTC_CIFS[$i]} $NETAPP_PROTOCOL_CIFS rw,nouser,username=$NETAPP_CIFS_USERNAME,password=$NETAPP_CIFS_PASSWORD 0 0" >> /etc/fstab 
                 
            fi
        done
     fi
    if [ "$NETAPP_PROTOCOL_NFS" == "nfs" ] && [ "$NETAPP_NO_VOLUME_NFS" -gt "0" ]; then
          apt-get install -y nfs-common #installation of nfs protocol
          for (( i=0; i<$NETAPP_NO_VOLUME_NFS; i++ ))
          do
              if [ -d ${NETAPP_MOUNTC_NFS[$i]} ]; then 
              	 echo "${NETAPP_MOUNT_IP}:${NETAPP_MOUNTS_NFS[$i]}  ${NETAPP_MOUNTC_NFS[$i]}  $NETAPP_PROTOCOL_NFS rw,nouser,noatime,exec,nolock,bg,actimeo=1800     0 0" >> /etc/fstab
                  
              else
                  mkdir -p ${NETAPP_MOUNTC_NFS[$i]}
                  echo "${NETAPP_MOUNT_IP}:${NETAPP_MOUNTS_NFS[$i]}  ${NETAPP_MOUNTC_NFS[$i]}  $NETAPP_PROTOCOL_NFS rw,nouser,noatime,exec,nolock,bg,actimeo=1800     0 0" >> /etc/fstab
                  
              fi
          done
    fi   
fi    
    mount -a
