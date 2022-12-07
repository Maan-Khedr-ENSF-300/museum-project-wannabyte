import mysql.connector
from tabulate import tabulate

def guest_view(cur):
    print('Welcome to the guest browser')
    while(True):
        print('What would you like to view?')
        print('1-Art Pieces')
        print('2-Artists')
        print('3-Exhibitions')
        print('4-Quit')
        selection = input('Please enter your choice: ')
        while selection not in ['1', '2', '3', '4']:
            selection = input('Invalid input.\nPlease enter a valid choice: ')
        if selection == '4':
            print('Thank you for using our database!')
            break
        elif selection == '1':
            choice = input('Would you like to see:\n1-Paintings\n2-Sculptures\n3-Statues\n4-Other')
            if choice == '1':
                cur.execute('''SELECT A.title, A.descrip as Description, A.year_created, A.Epoch,
                        A.Country_of_origin, A.AFname as Artist_first_name, A.ALname as Artist_last_name,
                        P.Paint_type, P.Drawn_on, P.Style FROM art_object AS A JOIN painting AS P ON A.ID_no = P.ID_no''')
                display_data(cur)
            elif choice == '2':
                cur.execute('''SELECT A.title, A.descrip as Description, A.year_created, A.Epoch,
                        A.Country_of_origin, A.AFname as Artist_first_name, A.ALname as Artist_last_name,
                        P.Material, P.Height, P.weight_in_kg, P.style FROM art_object AS A JOIN sculpture AS P ON A.ID_no = P.ID_no''')
                display_data(cur)
            elif choice == '3':
                cur.execute('''SELECT A.title, A.descrip as Description, A.year_created, A.Epoch,
                        A.Country_of_origin, A.AFname as Artist_first_name, A.ALname as Artist_last_name,
                        P.Material, P.Height, P.weight_in_kg, P.Style FROM art_object AS A JOIN statue AS P ON A.ID_no = P.ID_no''')
                display_data(cur)
            elif choice == '4':
                cur.execute('''SELECT  A.title, A.descrip as Description, A.year_created, A.Epoch,
                        A.Country_of_origin, A.AFname as Artist_first_name, A.Lname as Artist_las_name,
                        P.Otype as Object_type, P.Style FROM art_object AS A JOIN other AS P ON A.ID_no = P.ID_no''')
                display_data(cur)
            else:
                print('invalid input')
                continue

        elif selection == '2':
            cur.execute('''SELECT Fname as First_name, Lname as Last_name, Year_born, Year_died
            country_of_origin, Epoch, Main_style, Descrip as description FROM artist''')
            display_data(cur)

        elif selection == '3':
            choice = input('Would you like to view:\n1-Current Exhibitions\n2-Past Exhibitions\nPlease enter your choice: ')
            if choice == '1':
                cur.execute('SELECT Ename as Exhibit_name, Startdate, Enddate FROM exhibition WHERE enddate IS NOT NULL')
                display_data(cur)
                exhibit_info(cur)

            elif choice == '2':
                cur.execute('SELECT Ename as Exhibit_Name, Startdate FROM exhibition WHERE enddate IS NULL')
                display_data(cur)
                exhibit_info(cur)
            
            else:
                print('Invalid input.')
                continue
        
def exhibit_info(cur):
    print('Would you like to see what objects are in an exhibit?')          
    choice = input('Y for Yes, anything else for No: ')  
    if choice == 'Y' or choice == 'y':
        exhibit = input('Please enter the name of the exhibit you want to view: ')
        try:
            cur.execute(f"SELECT A.title as Artpiece_Title from art_object as A join exhibit as E ON A.ID_no = E.ID_no WHERE E.Ename = '{exhibit}'")
            display_data(cur)
        except mysql.connector.Error:
            print('Error, name invalid.')
            return
    else:
        return
            
def display_data(cur):
    result = cur.fetchall()
    print(tabulate(result, headers=cur.column_names, tablefmt='psql'))

def data_entry(cur):
    print('Would you like add new data or modify existing data?')
    print('1 - Add Data')
    print('2 - Modify exisiting data')
    print('3 - Quit')
    choice = input('Please enter your decision: ')
    while choice not in ['1', '2', '3']:
        choice = input('Please select a valid choice: ')
    if choice == '1':
        print('Available tables to add data are:\n')
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'art_museum'")
        options = []
        for table in [tables[0] for tables in cur.fetchall()]:
            options.append(table)
        print(*options, sep=', ')
        tbl = input('Which table would you like to add data to: ')
        try: 
            cur.execute(f'SELECT * FROM {tbl}')
        except mysql.connector.Error:
            print('Error, name invalid')
            return
        values = []
        for i in range(len(cur.description)):
            descript = cur.description[i]
            print(f'Please enter data to add to column {descript[0]}: ')
            if descript[6] == 0:
                print('Note: Attribute may not be NULL')
            else:
                print('Note: If left empty, attribute will default to NULL')
            values.append(input())
        unpack = ", ".join(["'"+e+"'" for e in values])
        try:
            cur.execute(f'INSERT INTO {tbl} VALUES ({unpack})')
            cur.execute(f'SELECT * FROM {tbl}')
            print('Table after data added:')
            display_data(cur)
        except mysql.connector.Error as err:
            print(err)

    #elif choice == 2:
    
    elif choice == 3:
        print('Thank you for using our database!')
        exit()
        
    return

def admin_view(cur):
    while True:
        print('Would you like to:\n1-Execute an SQL command\n2-Run an SQL script\n3-Quit')
        choice = input('Please enter your selection: ')
        while choice not in ['1','2','3']:
            choice = input('Invalid input. Please enter a valid choice: ')
        if choice == '1':
            while True:
                query = input('Please enter the SQL command that you want to execute: ')
                try:
                    cur.execute(f'{query}')
                    display_data(cur)
                except mysql.connector.Error as e:
                    print(e)
                cont = input('Would you like to execute another command?\nY for yes, anything else for no: ')
                if cont not in ['Y', 'y']:
                    break
        elif choice == '2':
            while True:
                print('Please enter the directory and file name of the script you want to run: ')
                print('NOTE: Please enter the directory and filename WITHOUT any quotation marks.')
                filepath = input()    
                fd = open(f'{filepath}', 'r')
                sqlFile = fd.read()
                fd.close()
                sqlCommands = sqlFile.split(';')

                for command in sqlCommands:
                    try:
                        if command.strip() != '':
                            cur.execute(command)
                    except mysql.connector.Error as msg:
                        print("Command skipped: ", msg)
                
                cont = input('Would you like to execute another file? Y for yes, anything else for no: ')
                if cont not in ['Y', 'y']:
                    break
        elif choice == '3':
            print('Thank you for using our database!')
            exit()
    
if __name__ == "__main__":
    
    print("Welcome to the Art Museum Database!")
    print("In order to proceed please select your role from the list below:")
    print("1-DB Admin")
    print("2-Data Entry")
    print("3-Browse as guest")
    print("0-Quit")

    selection = input("please type 1, 2, or 3 to select your role: ")
    while selection not in ['1', '2', '3', '0']:
        selection = input("Invalid input, please enter either 1, 2, 3, or 0: ")
    
    if selection == '0':
        print('Thank you for using our database!')
        exit()

    if selection in ['1','2']:
        username= input("user name:")
        passcode= input("password:")

    else:
        username="guest"
        passcode=None
    
    #Attempt to establish a connection
    try :
        cnx = mysql.connector.connect(
        user = username,
        password = passcode,
        autocommit = True
        )
        if (cnx.is_connected()):
            print("Connection Successful")
    
    except mysql.connector.Error as e:
        print(e)
        print('Exiting...')
        exit()   

    cur = cnx.cursor(buffered=True)
    cur.execute("use art_museum")


    if selection == '3':
        guest_view(cur)
    elif selection == '2':
        data_entry(cur)
    else:
        admin_view(cur)

