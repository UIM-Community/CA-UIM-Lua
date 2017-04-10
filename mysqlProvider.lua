--
-- Using a MySQL connection string
--
local mysql_dbase        = "mysqlnimsoftslm"        -- schema / databasename
local mysql_dbserver    = "server-name"            -- "server name or ip"
local mysql_user        = "root"                -- the username
local mysql_password    = ""                    -- the user password

if mysql_password ~= "" then
    -- Build connection string
    local cs = "Provider=MySQL;Initial Catalog="..mysql_dbase..";Data Source="..mysql_dbserver..";User ID="..mysql_user..";Password="..mysql_password..";Port=3306"

    local rc = database.open (cs,false)
    if rc == NIME_OK then
        local rs = database.query ("SELECT * FROM S_QOS_DATA")
        printf ("Number of QoS objects: %d",#rs)
    else
        print ("Failed to open database using the provided connection string!")
    end

    database.close()
end
