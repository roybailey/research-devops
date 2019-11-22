#!/bin/zsh
echo Running Developer Profile

# shell variables
ulimit -n 4096
ulimit -u 1024

# aliases
alias lastmodified='find . -type f -exec stat -f "%Sm %N" -t "%Y%m%d%H%M" {} \; | sort -r'

alias bitbucket="echo cd ~/Coding/bitbucket; cd ~/Coding/bitbucket"
alias github="echo cd ~/Coding/github; cd ~/Coding/github"
alias gitview="echo cd ~/Coding/gitview; cd ~/Coding/gitview"
alias temp="echo cd ~/Temp; cd ~/Temp"

alias gs="echo git status; git status"
alias gt="echo git tag; git tag"
alias gp="echo git pull; git pull"

alias mvnci="echo mvn clean install; mvn clean install"
alias mvndt="echo mvn dependency:tree; mvn dependency:tree"
alias mvnrun="echo mvn compile && mvn exec:java; mvn compile && mvn exec:java"
alias mvnversion='function _blah(){ echo "mvn versions:set -DnewVersion=$1"; mvn versions:set -DnewVersion=$1; };_blah'

alias grb="echo gradle build; gradle build"
alias grd="echo gradle dependencies; gradle dependencies"
alias grpom="echo gradle pom; gradle pom"

alias npm-global-ls="echo npm -g ls --depth 0; npm -g ls --depth 0"
alias npm-tape="echo npm run tape; npm run tape"
alias babel-tape="echo tape -r babel-register; tape -r babel-register"

alias btoff="sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport"
alias bton="sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport"

TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR
APPS=~/Coding/apps

# ============================================================
# Java
# ============================================================
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'

#default java8
if [[ ! -a ~/Coding/apps/java ]]; then
    ln -s $JAVA_8_HOME ~/Coding/apps/java
fi

JAVA_HOME=$APPS/java; export JAVA_HOME;
PATH=$PATH:$JAVA_HOME/bin; export PATH;

# ============================================================
# Ant
# ============================================================
ANT_HOME=$APPS/ant; export ANT_HOME;
PATH=$PATH:$ANT_HOME/bin; export PATH;

# ============================================================
# Maven
# ============================================================
MAVEN_HOME=$APPS/maven; export MAVEN_HOME;
M2_HOME=$MAVEN_HOME
PATH=$PATH:$MAVEN_HOME/bin; export PATH;

# ============================================================
# Gradle (brew install gradle - /usr/local/bin/gradle)
# ============================================================
# GRADLE_HOME=$APPS/gradle; export GRADLE_HOME;
# PATH=$PATH:$GRADLE_HOME/bin; export PATH;

# ============================================================
# nvm (brew install nvm; mkdir `/.nvm)
# ============================================================
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
