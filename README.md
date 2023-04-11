# README
A repository to setup my control machine in my home lab.

## Pre-requisites
```
pip install boto3 botocore
ansible-galaxy collection install amazon.aws
```

## Usage
Setup my preferences
```
./main.yaml -t prefs
```

Setup my SSH private key
```
./main.yaml -t ssh
```
