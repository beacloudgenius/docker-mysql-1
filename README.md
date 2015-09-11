# docker-mysql
Run MySql, SQLBuddy, Adminer, and phpMyAdmin Insider Docker

## build
Run ```./build``` to build image.

## run
Run ```./run``` to run container.

## phpMyAdmin
Point browser to ```http://<host>/phpmyadmin```

## SQL Buddy
Point browser to ```http://<host>/sqlbuddy```

## Adminer
Point browser to ```http://<host>/adminer```

## data (optional)
1. Put your data into a file ```data.sql```.
2. In Dockerfile, uncomment the ```#data``` section.
3. Rebuild the image.
