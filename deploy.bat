@echo off
git add -A
git commit -m update
git pull origin master --allow-unrelated-histories
git push -f origin master
exit