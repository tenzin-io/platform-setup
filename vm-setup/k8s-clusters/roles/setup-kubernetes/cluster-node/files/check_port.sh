#!/bin/bash

PORT="$1"
ss -Htln "( sport = :$PORT )" | grep $PORT &> /dev/null
