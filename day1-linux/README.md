# README - DAY 1 Basic Linux Administration Guide

## nano filename

- Open a file for editing with nano.
- Save changes with Ctrl + O, then press Enter.
- Exit nano with Ctrl + X.
- Cut a line with Ctrl + K.
- Paste a line with Ctrl + U.

![alt text](</day-1/screen-short/nano-1.png>)

## cat Command

- Display the contents of a file.

![alt text](</day-1/screen-short/cat-group-grep.png>)

## Basic vim Commands

- Open a file with vim.
- Enter insert mode by pressing i.
- Save and exit with :wq.
- Exit without saving with :q!.
- Delete a line with dd.

![alt text](</day-1/screen-short/vim.png>)

## User and Group Management

`sudo adduser username`

- Add a new user.

![alt text](</day-1/screen-short/add-group.png>)


`sudo deluser username`

- Remove a user.

![alt text](</day-1/screen-short/del-user.png>)

`sudo groupadd groupname`

- Create a new group.

![alt text](</day-1/screen-short/group-add.png>)

## Understanding File Permissions

`ls -l filename`

- Check file permissions.

![alt text](</day-1/screen-short/file-permission.png>)

`chmod mode filename`

- Change file permissions (<e.g., chmod 755 filename>).

`sudo chown user:group filename`

- Change file ownership.

![alt text](</day-1/screen-short/file-permission.png>)

## Managing Services with systemctl

`sudo systemctl stop apache2`

- Stop the Apache2 service.

![alt text](</day-1/screen-short/service-stop.png>)

`sudo systemctl status apache2`

- View the status of the Apache2 service.

![alt text](</day-1/screen-short/status-service.png>)

## Process Handling

`ps aux`

- View all running processes.

![alt text](</day-1/screen-short/process.png>)

`kill PID`

- Kill a process (<e.g., kill 1263>).

`renice priority PID`

- Change the priority of a process (<e.g., renice 10 8132>)

![alt text](</day-1/screen-short/nice-renice.png>)
