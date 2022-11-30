# FirebirdSimpleIUDTest
Simple Insert Update Delete Test to measure Firebird performance on the specific hardware/OS/configuration

Test SQL script
To run the test, copy-paste the text below into the text file and change the path to the database - in the example, the connection string is in Firebird 3 TCP format, but you can change it to XNET (xnet://Disk:\path\database.fdb) or embedded (disk:\path\database.fdb) connection string.

Please use the same firebird.conf as you use normally (if you need to tune your configuration, create optimized configuration file here: https://cc.ib-aid.com/democalc.html).
This test creates a database, creates a table with several indices, and then performs the 1 million of INSERT, UPDATE, and DELETE operations.
If you have stored sql file into c:\temp\dml-basic-benchmark.sql, please run this script with the following command:

isql -i c:\temp\dml-basic-benchmark.sql

This script will create a database approximately 3.6Gb in size. Don't forget to delete it after the test.


