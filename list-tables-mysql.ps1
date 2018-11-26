﻿# This script lists all of the tables in a MySQL database and exports the list as a CSV
# Install-Module InvokeQuery
# Run the above command if you do not have this module
param($server,$database,$dbuser,$dbpass)
$csvfilepath = "$PSScriptRoot\mysql_tables.csv"
$result = Invoke-MySqlQuery  -ConnectionString "server=$server; database=$database; user=$dbuser; password=$dbpass; pooling = false; convert zero datetime=True" -Sql "SHOW TABLES" -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation