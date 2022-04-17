# README

## System 

* ruby 2.7.4
* rails 6.1.4
* sqlite3

## Setup
```
 $ bundle install
```


## Reset database & run seed data

```
 $ make testapp-seed
```

## Unit test

```
 $ rspec
```

## Authentication
run server default port `localhost:3000`

Sign up first here `users/`
keep token from header then using in sign in Authorization

```
Example

Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI3Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjUwMDkwNDAzLCJleHAiOjE2NTAzNDk2MDMsImp0aSI6IjkzMjY5YWRkLTA0YWQtNGMwMS05YmQ3LTJjMGVlYjMxMDNiOCJ9.Wk5iTzySRsHJKDBKuArQCCY9bZp3YIy8z-ivb2OAigs
```

***Remember to use your own auth token. This token won’t work for you.***

Sign in here `users/sign_in` 
