import string
import random

def GeneratePassword (passLength):
    password = string.ascii_letters + string.digits + "!@#$%^&*()_+=-./?><|\}{[]"
    passwordList = []
    for passChar in range(passLength):
        passRandom = random.choice(password)
        passwordList.append(passRandom)

    finalOutput = "".join(passwordList)
    return finalOutput
