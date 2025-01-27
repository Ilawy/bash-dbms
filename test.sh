cd modules
MODULES_DIR="."
for test in *_test.sh; do
    echo "running $test"
    bash $test
    echo "============="
done
