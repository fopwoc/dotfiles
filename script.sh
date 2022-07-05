git filter-branch --commit-filter '

    # check to see if the committer (email is the desired one)
    if [ "$GIT_COMMITTER_EMAIL" = "idolmaster1707@gmail.com" ];
    then
            # Set the new desired name
            GIT_COMMITTER_NAME="Ilya Dobryakov";
            GIT_AUTHOR_NAME="Ilya Dobryakov";

            # Set the new desired email
            GIT_COMMITTER_EMAIL="aspirin@govno.tech";
            GIT_AUTHOR_EMAIL="aspirin@govno.tech";

            # (re) commit with the updated information
            git commit-tree -f "$@";
    else
            # No need to update so commit as is
            git commit-tree -f "$@";
    fi' 
HEAD
