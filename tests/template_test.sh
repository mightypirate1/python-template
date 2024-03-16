TEST_REPO_NAME="repo-test"
TEST_REPO_SLUG="repo_test"


function create-and-build-test-repo () {
    echo "Creating test-repo..."
    bash -c " \
	    mkdir .test_repo && \
	    cd .test_repo && \
	    cookiecutter  --no-input .. repository_name=$TEST_REPO_NAME && \
        cd $TEST_REPO_NAME && \
        make develop \
    "
    add-test-code-to-repo
}


function add-test-code-to-repo () {
    echo "Adding a simple module to the repo..."
    local MODULE_FILE=.test_repo/$TEST_REPO_NAME/$TEST_REPO_SLUG/repo_module.py
    local INIT_FILE=.test_repo/$TEST_REPO_NAME/$TEST_REPO_SLUG/__init__.py

    echo '""" This is a test module """' >> $MODULE_FILE && \
    echo "" >> $MODULE_FILE && \
    echo "" >> $MODULE_FILE && \
    echo "def square(number: int) -> int:" >> $MODULE_FILE && \
    echo "    return number**2" >> $MODULE_FILE && \
	echo "from $TEST_REPO_SLUG.repo_module import square" >> $INIT_FILE
}


function clean-test-repo () {
    rm -rf .test_repo
}


function run-in-test-repo-venv () {
    COMMAND=$@
    bash -c "\
        cd .test_repo/$TEST_REPO_NAME && \
        source .venv/bin/activate && \
        $COMMAND \
    "
}


function test-functionality () {
    local PYTHON_COMMAND='"'"from $TEST_REPO_SLUG import square; square(7)"'"'
    run-in-test-repo-venv "python -c $PYTHON_COMMAND"
}


function test-repo-is-created () {
    bash -c "\
        cd .test_repo/$TEST_REPO_NAME && \
        source .venv/bin/activate \
    "
}


function run-all-repo-tests () {
    test-repo-is-created && \
    run-in-test-repo-venv "make test" && \
    run-in-test-repo-venv "make coverage" && \
    run-in-test-repo-venv "make lint" && \
    test-functionality
}


function report-success () {
    echo "Test passed!"
    exit 0
}


function report-failure () {
    echo "Test FAILED!"
    exit 1
}


if [[ $# -ne 1 ]]; then
    echo "Takes exactly one argument: <full-test|clean|create|test-all|test-lint|test-tests|test-coverage|test-module>"
    exit 1
fi


case $1 in

    repo-test )
        clean-test-repo
        create-and-build-test-repo && run-all-repo-tests && clean-test-repo
    ;;

    clean )
        clean-test-repo
    ;;

    create-test-repo )
        clean-test-repo
        create-and-build-test-repo
    ;;

    test-all )
        run-all-tests
    ;;

    test-lint )
        test-repo-is-created && run-in-test-repo-venv "make lint"
    ;;

    test-tests )
        test-repo-is-created && run-in-test-repo-venv "make test"
    ;;

    test-coverage )
        test-repo-is-created && run-in-test-repo-venv "make coverage"
    ;;

    test-module )
        test-repo-is-created && test-functionality
    ;;

    test-docker )
        if [[ "$GPR_DEPLOY2_API_KEY" = "" ]]; then
            GPR_DEPLOY2_API_KEY=$GITHUB_TOKEN
        fi
        test-repo-is-created && run-in-test-repo-venv "docker build . --build-arg github_token=$GPR_DEPLOY2_API_KEY"
    ;;

    * )
        echo "Invalid argument: $1"
        exit 1
    ;;

esac

if [[ $? -gt 0 ]]; then
    report-failure
else
    report-success
fi