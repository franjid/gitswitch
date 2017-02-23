#!/bin/zsh

GIT_SWITCH_IDENTITIES_FILE=~/.gitswitch
GIT_CONFIG_FILE=~/.gitconfig

declare -A identitiyEmailArray
declare -a identitiesArray
count=1

# Read identities
cat $GIT_SWITCH_IDENTITIES_FILE | while read line
do
    if [[ $line == '['* ]]; then
        identityId="$(echo $line | sed 's/^\[\(.*\)\]$/\1/g')"
        identitiesArray[$count]=$identityId
        count=$((count+1))
    elif [[ $line == 'email='* ]]; then
        email="$(echo $line | sed 's/^\email=\(.*\)$/\1/g')"
    fi

    identitiyEmailArray[$identityId]=$email
done

echo "## Possible options ##\n"

count=1
for each in "${identitiesArray[@]}"
do
  echo "($count)" "$each" " \t -> email = $identitiyEmailArray[$each]"
  count=$((count+1))
done

echo "\nWhich option do you want to use? "
read option

emailChosen=$identitiyEmailArray[$identitiesArray[$option]]

# Remove lines with previous references to the chosen email
sed -i '' '/email = '$emailChosen'/d' $GIT_CONFIG_FILE

# Comment out other emails in use
sed -i '' 's/#email = \(.*\)/email = \1/g' $GIT_CONFIG_FILE
sed -i '' 's/email = \(.*\)/#email = \1/g' $GIT_CONFIG_FILE

# Set chosen email
sed -i '' 's/^\[user\]$/[user]\
    email = '$emailChosen'/' $GIT_CONFIG_FILE

echo "Current Git email:" "$(git config user.email)"
