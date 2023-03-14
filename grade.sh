CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf tests

git clone $1 student-submission
echo "--------------------------------"
echo "Finished cloning"
echo "--------------------------------"

FILE_PATH=$(find student-submission/ -name "ListExamples.java" -type f)

if [[ -z "$FILE_PATH" ]]; then
    echo "Error: the file submitted has incorrect name or is missing" 
    exit 1
else 
    if [[ -e student-submission/ListExamples.java ]]; then
        if [[ -f student-submission/ListExamples.java ]]; then
            echo "Success: Found correct file"
            echo "--------------------------------"
        else
            echo "Error: the file submitted is not regular file"
            exit 1
        fi
    else
        echo "Error: the file submitted has correct name but in nested directory"
        exit 1
    fi
fi

mkdir tests
cp student-submission/ListExamples.java tests/
cp TestListExamples.java tests/
cp -R ./lib tests/

cd tests

javac -cp $CPATH *.java > compile-output.txt


if [[ $? -ne 0 ]]; then
    echo "Error: Compilation failed"
    echo "--------------------------------"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-output.txt

if grep -q "FAILURES!!!" test-output.txt; then
    FAILURES=$(grep "Failures:" test-output.txt | awk '{print $NF}' | cut -d':' -f2)
    echo "$FAILURES Test(s) Failed among 3 Tests"
    echo "--------------------------------"
    PERCENTAGE=$(printf "%.2f" $(echo "(3-$FAILURES)/3*100" | bc -l))
    echo "Total Grade: $PERCENTAGE%"
else
    echo "Test Succeed"
    echo "--------------------------------"
    echo "Total Grade: 100%"
fi
