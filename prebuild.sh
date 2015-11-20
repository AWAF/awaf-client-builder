#!/bin/sh

## CONSTS
REMOTEHOST="github.com"
REMOTEUSER="AWAF"
REMOTEREPOS="ajax loader errorhandler eventmanager animation"
MODULESDIR="./modules"

check_npm_deps (){
    echo "Checking availbility of npm...";
    npm -v 2>&1 >/dev/null;
    npm_available=$?;
    if [ $npm_available -eq 0 ];
    then
        echo "Npm installed. Installing dependencies...";
        npm install;
        npm_installed_deps=$?;
        if [ $npm_installed_deps -eq 0 ];
        then
            echo "Deps installed.";
            return 0;
        else
            echo "Deps aren't installed. Aborting...";
            return 20;
        fi
    else
        echo "Npm in not installed. Aborting...";
        return 10;
    fi
}

check_nodejs (){
    echo "Checking availbility of node...";
    nodejs -v 2>&1 >/dev/null;
    node_available=$?;
    if [ $node_available -eq 0 ];
    then
        echo "NodeJS installed.";
        return 0;
    else
        echo "NodeJS is not installed. Aborting...";
        return 10;
    fi
}

check_git (){
    echo "Checking availbility of git...";
    git --version 2>&1 >/dev/null;
    git_available=$?;
    if [ $git_available -eq 0 ];
    then
        echo "Git installed.";
        return 0;
    else
        echo "Git is not installed. Aborting...";
        return 10;
    fi
}

check_install (){
    check_git;
    git_available=$?;
    check_nodejs;
    node_available=$?;
    if [ $git_available -eq 0 ] && [ $node_available -eq 0 ];
    then
        check_npm_deps;
        npm_deps_available=$?;
        if [ $npm_deps_available -eq 0 ];
        then
            return 0;
        else
            return 20;
        fi
    else
        return 10;
    fi
}

git_clone (){
    for repo in $REMOTEREPOS
    do
        git clone "https://"$REMOTEHOST"/"$REMOTEUSER"/"$repo $MODULESDIR"/"$repo;
        git_status=$?;
        if [ $git_status -ne 0 ];
        then
            return 10;
        fi
    done
    return 0;
}

main (){
    check_install;
    check_status=$?;
    if [ $check_status -eq 0 ];
    then
        echo "All needed is installed. Cloning module repos...";
        git_clone;
        git_all_status=$?;
        if [ $git_all_status -ne 0 ];
        then
            echo "Cloning failed. Read the output for more information.";
            exit 20;
        else
            echo "All modules cloned.";
            exit 0;
        fi
    else
        echo "Check install failed. Read the output for more information.";
        exit 10;
    fi
}

main;
