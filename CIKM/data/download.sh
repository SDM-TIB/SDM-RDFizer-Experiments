#!/bin/bash

mkdir simple
mkdir complex
cd simple
wget -O data.zip https://delicias.dia.fi.upm.es/nextcloud/index.php/s/BBFFYYRJ3Ag9QDn/download
unzip data.zip
cd ../complex
wget -O data-source10.zip https://delicias.dia.fi.upm.es/nextcloud/index.php/s/EGyr8EGAYwKqmD8/download
unzip data-source10.zip