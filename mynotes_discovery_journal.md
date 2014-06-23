# My path of discoveries

## os issues + secuirty issues

1. tried to pass custom kernel variables, no password required (made puppet module)
1. what is allowed by the pam.d? there exsits nullok in /etc/pam.d/system-auth
1. tried going to single user mode (no password was required)
1. tried to telnet into the mail port to see what i got, found the program name "postfix" (this should be hidden)
1. went through the config files in general, httpd.conf, php.ini, my.cnf

## apache issues journal

1. what is the hosts name? does it know about itself? cat /etc/hosts says it does not
1. tried to access url localhost:8080 but got response code 403 Forbidden
1. checking log files in /var/log/httpd/
1. noticed in http logs: client denied by server configuration: /var/www/html/
1. checking config files for the problems in the directory, using apachectl utility to display files loaded
1. running "httpd -V" to determain conf file loaded by default
1. checking centos sysconfig/httpd file for any options passed
1. everything is commented out on the sysconfig/httpd
1. there are too many modules loaded, this could be considered a security risk
1. running as user apache and group apache (this is normal, possible that folders are wrong permissions, not sure yet)
1. the setting of "ServerSignature On" is not good for production, allowing for sharing information that is not necessary
1. found nothing else of significance in the httpd.conf file, moving on to conf.d directory that was included, starting off with file that is loaded first by alphanumeric sorting
1. while editing the virtual.conf file, noticed the "Allow from localhost" would only allow connections from the ip address set in /etc/hosts (usually 127.0.0.1)
1. adding new line to virtual.conf "Allow from 10.0.2.2"
1. checking syntax to make sure a clean restart occures (could also launch an alternative apache on sepearte port to avoid bringing down production env)
1. now im getting a 404 not found, continuing troubleshooting
1. noticed there are rewrite rules in both the virtual.conf file and in the file .htaccess located at /var/www/html
1. i have commented out the /var/www/html/.htaccess rules to remove duplication of redirecting
1. fixed rewrite rule in /etc/httpd/conf.d/virtual.conf to point to data.php
1. reloaded page and got screen shot with mysql error message of failing to connect to database

## php talking to mysql issues journal

1. (Started after walking through Apache issues)
1. (at this point, while working on this problem, i would write a short email to the owner and request that the username and database be changed right away, the named  "test" should never be used, if there is a need for an account to be used for testing, we should name it something else that is not the default, also there should be at minimum be two accounts for an applicaton, 1 for read, and 1 for read+write+delete, could be a third for dropping tables if that is necessary )
1. parsed through the data.php file and noticed the mysqli_connect with the parameters being passed
1. attempting to connect with the parameters being passed with they mysql cli client (this is to verify the error message is the same without using php)
1. got error of attempting to connect with the mysql cli client and it matched what the website is saying
1. connecting to mysql with root user to determain list of accounts and permissions and to fix permissions for the test account
1. running the command "use mysql" then "select * from user\G" displayed the accounts, but i saw no account named "test"
1. determained the next action would be to create the test account with the predetermained password in the php file
1. (goto mysql issues log to document creating account)
1. reloaded the website and I received the logo and a cyan blue box with the text "Well hello there."

## mysql issues

1. the mysql failed to start
1. checking log file for any information
1. noticed : /usr/libexec/mysqld: Can't find file: './mysql/plugin.frm' (errno: 13)
1. noticed : 140621 17:06:30 [ERROR] Can't open the mysql.plugin table. Please run mysql_upgrade to create it.
1. notices : InnoDB: File name ./ibdata1 (mysqld does not have the access rights)
1. notices : 140621 17:19:49 [ERROR] /usr/libexec/mysqld: Can't create/write to file '/var/run/mysqld-pid/mysqld.pid' (Errcode: 2)
1. seems like the bash shell script has the wrong directory for creating the file that holds the PID number of the parent process
1. need to trace the bash script to find out why its using mysqld-pid, it should be using /var/run/mysqld
1. running bash -x /etc/init.d/mysqld start to show variables
1. i see the results variable is where the path mysqld-pid first shows up
1. did a search in the bash script and did not find anything
1. looking for other sources of variables settings, checking /etc/my.cnf
1. found the mystry entry. changing its value.
1. noticed that i was able to login with a blank password when using this command: "mysql -u 'root'@'broken.box.local' -p"
1. on mysql, the user account "root" should be renamed to something besides the default
1. running "SHOW GRANTS;" displayed that another user is allowed usage on all databases and tables: "GRANT USAGE ON *.* TO ''@'localhost'"
1. this can allow an account to see any information on any database and table, including the mysql tables where accounts are stored
1. running command "SET SQL_LOG_BIN=0" (to disable logging as i am using the root account)
1. while this goes against leading security practice, and i have been requested to use the test account and database, i proceeded with the command to grant access to the test user with: GRANT SELECT ON test.data TO 'test'@'localhost' IDENTIFIED BY 'broken';