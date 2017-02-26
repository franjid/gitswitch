#!/bin/zsh

GIT_SWITCH_IDENTITIES_FILE=~/.gitswitch
GIT_CONFIG_FILE=~/.gitconfig

declare -A identityNameArray
declare -A identityEmailArray
declare -a identitiesArray
count=1

echo "Current Git name and email:" "$(git config user.name);$(git config user.email)\n"

# Read identities
cat $GIT_SWITCH_IDENTITIES_FILE | while read line
do
    if [[ $line == '['* ]]; then
        identityId="$(echo $line | sed 's/^\[\(.*\)\]$/\1/g')"
        identitiesArray[$count]=$identityId
        count=$((count+1))
    elif [[ $line == 'name='* ]]; then
        identityNameArray[$identityId]="$(echo $line | sed 's/^name=\(.*\)$/\1/g')"
    elif [[ $line == 'email='* ]]; then
        identityEmailArray[$identityId]="$(echo $line | sed 's/^email=\(.*\)$/\1/g')"
    fi
done

echo "## Possible options ##"

count=1
for each in "${identitiesArray[@]}"
do
  echo "($count)" "$each" " \t -> $identityNameArray[$each];$identityEmailArray[$each]"
  count=$((count+1))
done

printf '\nSelect option: '
read -r option

nameChosen=$identityNameArray[$identitiesArray[$option]]
emailChosen=$identityEmailArray[$identitiesArray[$option]]

# Remove lines with previous references to the chosen name and email
sed -i '' '/name = '$nameChosen'/d' $GIT_CONFIG_FILE
sed -i '' '/email = '$emailChosen'/d' $GIT_CONFIG_FILE

# Uncomment previous commented name and emails as otherwise we end up with lines like #######email=whatever
sed -i '' 's/#name = \(.*\)/name = \1/g' $GIT_CONFIG_FILE
sed -i '' 's/#email = \(.*\)/email = \1/g' $GIT_CONFIG_FILE
# Comment out any other name and email in use
sed -i '' 's/name = \(.*\)/#name = \1/g' $GIT_CONFIG_FILE
sed -i '' 's/email = \(.*\)/#email = \1/g' $GIT_CONFIG_FILE

# Set chosen name and email
sed -i '' 's/^\[user\]$/[user]\
    email = '$emailChosen'/' $GIT_CONFIG_FILE
sed -i '' 's/^\[user\]$/[user]\
    name = '$nameChosen'/' $GIT_CONFIG_FILE

echo "Current Git name and email:" "$(git config user.name);$(git config user.email)"
