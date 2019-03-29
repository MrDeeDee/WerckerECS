#!/bin/sh
set -e


if [ -z "$WERCKER_SCP_DEPLOY_HOST" ]
then
    fail 'missing host option, please add this the scp-deploy step in wercker.yml'
fi

if [ -z "$WERCKER_SCP_DEPLOY_SSHPRIVATEKEY" ]
then
    fail 'missing sshprivatekey option, please add this the scp-deploy step in wercker.yml'
fi

if [ -z "$WERCKER_SCP_DEPLOY_USER" ]
then
    fail 'missing user option, please add this the scp-deploy step in wercker.yml'
fi

if [ -z "$WERCKER_SCP_DEPLOY_DESTINATION" ]
then
    fail 'missing destiation option, please add this the scp-deploy step in wercker.yml'
fi

if [ -z "$WERCKER_SCP_DEPLOY_HIDE_SSH_CNX_INFO_FROM_LOG" ]
then
    fail 'missing hide-ssh-cnx-info-from-log option, please add this the scp-deploy step in wercker.yml'
fi

if [ -z "$WERCKER_SCP_DEPLOY_SSHPORT" ]
then
    fail 'missing sshport option, please add this the scp-deploy step in wercker.yml or something went wrong with the defaults'
fi

if [ -z "$WERCKER_SCP_DEPLOY_SOURCE" ]
then
    fail 'missing source option, please add this the scp-deploy step in wercker.yml or something went wrong with the defaults'
fi

CMD_='scp -r -P $WERCKER_SCP_DEPLOY_SSHPORT -i $WERCKER_SCP_DEPLOY_SSHPRIVATEKEY $WERCKER_SCP_DEPLOY_SOURCE $WERCKER_SCP_DEPLOY_USER@$WERCKER_SCP_DEPLOY_HOST:$WERCKER_SCP_DEPLOY_DESTINATION'

if [[ "$WERCKER_SCP_DEPLOY_HIDE_SSH_CNX_INFO_FROM_LOG" = "false" ]]
then
    info $CMD_
fi

if [ ! -d $HOME/.ssh ]
then
    mkdir $HOME/.ssh
fi

ssh-keyscan -H $WERCKER_SCP_DEPLOY_HOST >> $HOME/.ssh/known_host
echo $WERCKER_SCP_DEPLOY_SSHPRIVATEKEY >> $HOME/.ssh/id_rsa
scp -r -P $WERCKER_SCP_DEPLOY_SSHPORT -i $WERCKER_SCP_DEPLOY_SSHPRIVATEKEY $WERCKER_SCP_DEPLOY_SOURCE $WERCKER_SCP_DEPLOY_USER@$WERCKER_SCP_DEPLOY_HOST:$WERCKER_SCP_DEPLOY_DESTINATION

if [[ $? -ne 0 ]]; then
    fail "something went wrong :/ \n $CMD_";
else
    success "all green :D";
fi