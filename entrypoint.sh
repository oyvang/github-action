#!/bin/sh -l

# Get latest google java formatter from github
google_java_format_download_link=$(curl -s https://api.github.com/repos/google/google-java-format/releases/latest  | jq -r ".assets[] | select(.name | test(\".all-deps.jar\")) | .browser_download_url")
curl -s -L "$google_java_format_download_link" -o /google-java-format.jar

# analyze
work_dir=$1
cd $work_dir
> /diff
find . -name "*.java" -exec java -jar /google-java-format.jar --dry-run {} >> /incorrect-formatted-files \;
if [ -s /incorrect-formatted-files ];
then
  echo "Need some work on that linting..."
  git init
  git commit -m "before"
  while read incorrect_formatted_file; do
    echo "$incorrect_formatted_file"
    java -jar /google-java-format.jar --replace $incorrect_formatted_file
    git diff $incorrect_formatted_file >> /changed-files-diff
    cat /changed-files-diff
  done < /incorrect-formatted-files
  exit 1
else
  echo "Linting is perfect, good job!"
  exit 0
fi
