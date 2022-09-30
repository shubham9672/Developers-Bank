import pymysql.cursors# Database connection sentenceconnection = pymysql.connect(host='localhost',
                             user='root',
                             password='',
                             db='students',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)try:
    with connection.cursor() as cursor:        # single line reading
        sql = "SELECT `id`, `firstname`,`lastname` FROM `users`"
        cursor.execute(sql)        for row in cursor.fetchall():
            #read all lines
            firstname = str(row["firstname"])
            lastname = str(row["lastname"])            #print on screen
             print("firstname : " + firstname)
             print("lastname : " + lastname)finally:
        connection.close()
