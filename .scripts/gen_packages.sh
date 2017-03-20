#!/bin/bash

for d in stable/*
do
    # Will generate a helm package per chart folder
    echo $d
    helm package $d
done
