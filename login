import sys
import sqlite3
import os
import misc as misc
from PyQt6.QtGui import QPixmap
from PyQt6 import QtCore
from PyQt6.QtWidgets import (QLabel, QVBoxLayout, QHBoxLayout, QWidget, 
    QPushButton, QLineEdit)

# creates login window class
class LoginWindow(QWidget):
    # initialize window
    def __init__(self):
        super(LoginWindow, self).__init__()
        self.userEditLine = QLineEdit("User")
        self.passwordEditLine = QLineEdit("Password")
        toprow = QHBoxLayout()
        toprow.addWidget(self.userEditLine)
        toprow.addWidget(self.passwordEditLine)

        bottomrow = QHBoxLayout()
        self.loginButton = QPushButton("Login")
        self.loginButton.clicked.connect(self.login_click)
        self.cancelButton = QPushButton("Cancel")
        self.cancelButton.clicked.connect(self.exit_app)
        self.passwordEditLine.setEchoMode(QLineEdit.EchoMode.Password)
        bottomrow.addWidget(self.loginButton)
        bottomrow.addWidget(self.cancelButton)

        mainlayout = QVBoxLayout()
        mainlayout.addLayout(toprow)
        mainlayout.addLayout(bottomrow)
        
        imageLabel = QLabel()

        # create filepath and pixmap
        filepath = os.path.dirname(os.path.realpath(__file__) + '/icons/icon.login.png')
        pixmap = QPixmap(filepath)
        imageLabel.setPixmap(pixmap.scaled(100, 100))
        
        self.setWindowModality(QtCore.Qt.WindowModality.ApplicationModal)
        self.setWindowFlags(QtCore.Qt.WindowType.CustomizeWindowHint)

    # check login credentials for user  
    def check_username_password(self):
        filename = os.path.dirname(os.path.realpath(__file__)) + '/users.db'
        con = sqlite3.connect(filename)
        cur = con.cursor()
        res = cur.execute("SELECT * FROM UsersTable")
        data = res.fetchall()
        found = False
        for user_data in data:
            user = self.userEditLine.text()
            password =  self.passwordEditLine.text()
            if user_data[0] == user and user_data[1] == password:
                found = True
                break
        return found    
    
    # function to prompt login to user
    def login_click(self):
        if self.check_username_password():
            self.close
        else:
            self.passwordEditLine.setText(None)
            misc.show_message('user and password cannot be found', 'Login Error')

    # function to exit app
    def exit_app(self):
        response = misc.exit_message('are you sure you want to exit?', 'Exit App')
        if response:
            sys.exit()
    
    



