import CreatePasswords as MyPassword


while 1:
    userPasswordLength = int(input("Enter Length For Your Password: \n"))
    print(MyPassword.GeneratePassword(userPasswordLength))
    userReply = input("Do You Want More? (y,n): ")
    if userReply.lower() == "y" :
        continue
    elif userReply.lower() == "n":
        break