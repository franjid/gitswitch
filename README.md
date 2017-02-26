# Git Switch

Switch your Git identity between several options (personal, work, etc)

## Why?

While working in my current company it often happened that in the mornings I was committing like crazy with my corporate email and in the afternoon, before I start working on personal projects, I had to edit my .gitconfig file to comment the company email and uncomment my personal one.

Programmers are known for their lazyness, and this is just confirming that fact. I got tired of doing that every day, so I programmed an script to do it for myself.

## Set up

Edit .gitswitch file and replace it with the values you wish

Copy .gitswitch to your $HOME folder

```
cp .gitswitch ~
```

Copy script to a location where you can run it everywhere

```
cp gitswitch.sh /usr/local/bin/gitswitch
```

Run the command and choose one of the identities
```
gitswitch
```

In case (you don't trust me and) you want to check by yourself that it was correctly changed

```
git config user.name
git config user.email
```

**Profit!**

## Extra tip for lazy people (like me)

I added an alias on my system so I even have to type less. Maybe you want to make use of it too :)

```
alias gsw='gitswitch'
```
