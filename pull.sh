#!/bin/bash
echo "Pulling data from git"
git stash push -m lazy && git pull --rebase && git checkout --theirs lazy-lock.json && git stash pop
echo "All done"
