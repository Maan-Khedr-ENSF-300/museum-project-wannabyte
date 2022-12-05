import mysql.connector
from tabulate import tabulate

def guest_view(cur):
    print('Welcome to the guest browser\nWhat would you like to view?')
    cont = '1'
    while(cont == '1'):
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
            cont = '0'
        elif selection == '1':
            choice = input('Would you like to see:\n1-Paintings\n2-Sculptures\n3-Statues\n4-Other')
            if choice == '1':
                cur.execute('SELECT * FROM art_object AS A JOIN painting AS P ON A.ID_no = P.ID_no')
                display_data(cur)
            elif choice == '2':
                cur.execute('SELECT * FROM art_object AS A JOIN sculpture AS P ON A.ID_no = P.ID_no')
                display_data(cur)
            elif choice == '3':
                cur.execute('SELECT * FROM art_object AS A JOIN statue AS P ON A.ID_no = P.ID_no')
                display_data(cur)
            elif choice == '4':
                cur.execute('SELECT  * FROM art_object AS A JOIN other AS P ON A.ID_no = P.ID_no')
                display_data(cur)
            else:
                print('invalid input')
                continue

        elif selection == '2':
            cur.execute('SELECT * FROM artist')
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

def data_entry():
    return
def admin_view():
    return

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
        )
        if (cnx.is_connected()):
            print("Connection Successful")
    
    except mysql.connector.Error as e:
        print(e)
        print('Exiting...')
        exit()   

    cur = cnx.cursor()
    cur.execute("use art_museum")


    if selection == '3':
        guest_view(cur)
    elif selection == '2':
        data_entry(cur)
    else:
        admin_view(cur)

