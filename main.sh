#!/usr/bin/env bash

_showHelp() {
    tabs 2
    echo -e "\nCFT Entrance task\n"
    echo -e "Usage:\n\t$0 COMMAND\n"
    echo 'Commands:'
    echo -e "\tprepare\tInstall requirements"
    echo -e "\tgetStand\tDeploy VMs"
    echo -e "\tdeployServices\tDeploy services to VMs"
    echo -e "\runLoadTest\tRun HL test"
}

_installRequirements() {
    cd src

    if [[ -z $(pip list 2>/dev/null | grep -o virtualenv) ]]; then
        pip install virtualenv
    fi

    if [[ ! -d .venv ]]; then
        virtualenv .venv
    fi

    virtualenv .venv
    pip install -r requirements.txt

    chmod 0600 credentials/ssh-keys/awsTechKeyPair
}

_getStand() {
    cd src
    virtualenv .venv
    ansible-playbook --key-file=credentials/ssh-keys/awsTechKeyPair \
                     -e'stand_type=cft_entrance_task_lite' \
                     get-aws-stand.yml
}

_deployServices() {
    cd src
    if [[ ! -f inventory/hosts.ini ]]; then
        echo 'Inventory file is not found. Exiting...'
        exit 1
    fi
    virtualenv .venv
    ansible-playbook --key-file=credentials/ssh-keys/awsTechKeyPair \
                     -i'inventory/hosts.ini' \
                     deploy-services.yml
}

_runLoadTest() {
    cd src
    if [[ ! -f inventory/hosts.ini ]]; then
        echo 'Inventory file is not found. Exiting...'
        exit 1
    fi
    virtualenv .venv
    ansible-playbook --key-file=credentials/ssh-keys/awsTechKeyPair \
                     -i'inventory/hosts.ini' \
                     run-load-test.yml
}

COMMAND=$1

case $COMMAND in
    prepare) _installRequirements;;
    getStand) _getStand;;
    deployServices) _deployServices;;
    runLoadTest) _runLoadTest;;
    *) _showHelp;;
esac
