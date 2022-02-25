#! /bin/bash

#避免删除了旧的CodeSnippets， 先备份一份
mkdir ~/Library/Developer/Xcode/UserData/CodeSnippets/
mv ~/Library/Developer/Xcode/UserData/CodeSnippets ~/Library/Developer/Xcode/UserData/CodeSnippets.backup

#rm ~/Library/Developer/Xcode/UserData/CodeSnippets

SRC_HOME=`pwd`
mv ${SRC_HOME}/CodeSnippets ~/Library/Developer/Xcode/UserData/CodeSnippets
echo "code snippet imported"

