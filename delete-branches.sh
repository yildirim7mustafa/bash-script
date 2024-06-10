#!/bin/bash
mkdir /b2m

# Read the list of project repositories from proje_lists.txt
while IFS= read -r repo_url; do
    cd /b2m
    git clone $repo_url
    dir_name=$(echo $repo_url | grep -oP '(?<=/)[^/]+(?=\.git$)')
    echo  $dir_name
    cd "$dir_name"
    
    git branch -a > branches.txt

    # Process branches.txt and extract remote branch names
    while IFS= read -r full_string; do
        # Check if the line starts with 'remotes/origin/'
        echo $full_string | grep -o '/[^/]*$' | sed 's/\/\|//g' >> branches2.txt

    done < branches.txt

    # Read each branch from branches2.txt
    while IFS= read -r branch_name; do
        # Delete the remote branch
        git push origin --delete "$branch_name"
    done < branches2.txt
    
    cd /b2m
    
    rm -rf "$dir_name"

done < /b2m/proje_lists.txt