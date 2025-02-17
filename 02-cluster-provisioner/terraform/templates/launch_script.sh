#!/bin/bash

# Perform retries if failing download
echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries
