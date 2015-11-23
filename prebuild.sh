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
            return 2;
        fi
    else
        echo "Npm in not installed. Aborting...";
        return 1;
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
        return 1;
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
        return 1;
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
            return 2;
        fi
    else
        return 1;
    fi
}

git_clone (){
    for repo in $REMOTEREPOS
    do
        git clone --recursive "https://"$REMOTEHOST"/"$REMOTEUSER"/"$repo $MODULESDIR"/"$repo;
        git_status=$?;
        if [ $git_status -ne 0 ];
        then
            return 1;
        fi
    done
    return 0;
}

git_pull (){
    for repo in $REMOTEREPOS
    do
        cd $MODULESDIR"/"$repo;
        git pull;
        cd .."/"..;
    done
    return 0;
}

git_checkout (){
    for repo in $REMOTEREPOS
    do
        cd $MODULESDIR"/"$repo;
        git checkout $arg2;
        git_status=$?;
        if [ $git_status -ne 0 ];
        then
            return 1;
        fi
        cd .."/"..;
    done
    return 0;
}

## prebuild.sh
## Arguments: prebuild.sh [to <version>] | [update [<version>]] | [help]
main (){
    check_install;
    check_status=$?;
    if [ $check_status -eq 0 ];
    then
        echo "All needed is installed.";
        case $arg1 in
            to)
            if [ -z $arg2 ];
            then
                echo "Failed. \"to\" needs 1 extra argument (version)";
                exit 129;
            else
                echo "Cloning module repos...";
                git_clone;
                clone_ret_value=$?;
                if [ $clone_ret_value -ne 0 ];
                then
                    echo "Cloning failed. Read the output for more information.";
                    exit 131;
                else
                    echo "All modules cloned. Checkout version...";
                    git_checkout;
                    checkout_ret_value=$?;
                    if [ $checkout_ret_value -ne 0 ];
                    then
                        echo "Checkout failed. Read the output for more information.";
                        exit 132;
                    else
                        echo "All repositories set to version $2.";
                        exit 0;
                    fi
                fi
            fi
            ;;
            update)
            if [ -z $arg2 ];
            then
                arg2="HEAD";
            fi
            git_pull;
            git_checkout;
            checkout_ret_value=$?;
            if [ $checkout_ret_value -ne 0 ];
            then
                echo "Checkout failed. Read the output for more information.";
                exit 132;
            else
                echo "All repositories set to version $arg2.";
                exit 0;
            fi
            ;;
            help)
                echo "prebuild.sh [to <version>] | [update [<version]] | [help]";
                exit 1;
            ;;
            *)
            echo "Cloning module repos...";
            git_clone;
            clone_ret_value=$?;
            if [ $clone_ret_value -ne 0 ];
            then
                echo "Cloning failed. Read the output for more information.";
                exit 131;
            else
                echo "All modules cloned.";
                exit 0;
            fi
            ;;
        esac
    else
        echo "Check install failed. Read the output for more information.";
        exit 130;
    fi
}


echo "Args: $@";
arg1=$1;
arg2=$2;
main;
