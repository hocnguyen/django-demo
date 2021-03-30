#!/bin/sh -l
# if a command fails, exit
set -e
# treat unset variables as error
set -u
# if any command in a pipe fails, fail
set -o pipefail
# print all debug information
set -x


# This is populated by our secret from the Workflow file.
if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

find_base_commit() {
    BASE_COMMIT=$(
        jq \
            --raw-output \
            .pull_request.base.sha \
            "$GITHUB_EVENT_PATH"
    )
    # If this is not a pull request action it can be a check suite re-requested
    if [ "$BASE_COMMIT" == null ]; then
        BASE_COMMIT=$(
            jq \
                --raw-output \
                .check_suite.pull_requests[0].base.sha \
                "$GITHUB_EVENT_PATH"
        )
    fi
}

PULL_REQUEST_BRANCH=$(
        jq \
            --raw-output \
            .pull_request.head.ref \
            "$GITHUB_EVENT_PATH"
)

MERGED_BRANCH=$(
        jq \
            --raw-output \
            .pull_request.base.ref \
            "$GITHUB_EVENT_PATH"
)

ACTION=$(
    jq --raw-output .action "$GITHUB_EVENT_PATH"
)
# First 2 actions are for pull requests, last 2 are for check suites.
ENABLED_ACTIONS='synchronize opened requested rerequested'


main() {
    if [[ $ENABLED_ACTIONS != *"$ACTION"* ]]; then
        echo -e "Not interested in this event: $ACTION.\nExiting..."
        exit
    fi

    find_base_commit

    # Pull all branches references down locally so subsequent commands can see them
    git fetch origin "$MERGED_BRANCH" --update-head-ok
    git fetch origin "$PULL_REQUEST_BRANCH" --update-head-ok

    # Get files Added or Modified wrt base commit, filter for Python,
    # replace new lines with space.
    new_files_in_branch=$(
        git diff \
            --name-only \
            --diff-filter=AM \
            "$BASE_COMMIT" | grep '\.py$' || true | tr '\n' ' '
    )
if [ -z "$new_files_in_branch" ]
then
    echo "Don't have any .py file in check"
else
    # Feed to flake8 which will return the output in json format.
    # shellcheck disable=SC2086
    param="--ignore E127,E251,E126,E128,E131,E121,E226,E261,E262,E402,E265,E501,E401,E722,E502,N802,N806,N803,N812,F403,F401,W292,W391,N801,W504,N814,W503,F405"
    flake8 $param --format=json $new_files_in_branch | jq '.' > flake8_output.json || true # NOQA
    echo "New files in branch: $new_files_in_branch"
    python ./.github/actions/check_flake8/main.py
fi
}

main "$@"
