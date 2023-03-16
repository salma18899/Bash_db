#! /bin/bash
### script that handles customers info in file customers.db
# bash script manages user data
# Data files:
##      Customers.db:
##              id:name:email
##      accs:
##              id,username,pass
## operations:
##      ADD a customer
##      Delete a customer
##      update a customer email
##      Query a customer
##  Notes:
##      Add,Delete,update need Authentication
##      Query can be anonymous
##      Must be root to access the script
## Exit Codes:
##      0:Success
##      1:No customers.db file exists
##      2:No accs.db file exists
##      3:No read Perm on customers.db
##      4:No read perm on accs.db
##      5:must be root to run the script
##      6:
##      7:
source ./checks
source ./PrintMsgs.sh
source ./dbops.sh
CONT=1
USERID=0
## Function Takes a Parameter with username and return 0 if the user requested is the same as cuurent user

 #function CheckUser {
  #      RUSER=${1}
   #     [ ${RUSER} == ${USER} ] && return 0
    #    return 1



#}
AUTH=0
CONT=1
while [ ${CONT} -eq 1 ]
do

        PrintMainMenu
        read OP
        case "${OP}" in
                "a")
                        echo "Authentication:"
                        echo "---------------"
                        echo -n "Username: "
                        read ADMUSER
                        echo -n "Password: "
                        read -s ADMPASS
                        AuthenticateUser ${ADMUSER} ${ADMPASS}
                        USERID=${?}
                        if [ ${USERID} -eq 0 ]
                        then
                                echo  -e "\nInvalid username/password combination"
                        else
                                        echo -e  "\nWelcome to the system"
                        fi
                        ;;
                "1")

                        if [ ${USERID} -eq 0 ]
                        then
                                PrintErrorMsg "You are not authenticated, please authenticate 1st "
                        else
                                echo "Adding a new customer"
                                echo "---------------------"
                                echo -n "Enter customer ID : "
                                read CUSTID
                                # check for id is valid integer
                                checkInt ${CUSTID}
                                if [ ${?} -eq 0 ]
                                then
                                        echo "Invalid Integer"  
                                else
                                   # Check for userid exist or not
                                   CheckIdEX ${CUSTID}
                                      if [ ${?} -ne 0 ]
                                      then
                                         echo "ID  Exists"
                                      else
                                         echo -n "Enter customer name : "
                                         read CUSTNAME
                                   # check for customer name is only alphabet,-_
                                   checkName ${CUSTNAME}
                                      if [ ${?} -eq 0 ]
                                      then
                                         echo "Invalid Name"
                                      else
                                   # check for email format
                                         echo -n "Enter customer email : "
                                         read CUSTEMAIL
                                   checkMail ${CUSTEMAIL}
                                      if [ ${?} -eq 0 ]
                                      then
                                         echo "Invalid Email"
                                         else
                                   # Check for email exist or no
                                   CheckMailEX ${CUSTEMAIL}
                                      if [ ${?} -ne 0 ]
                                      then
                                         echo "Mail  Exists"            
                                      else
                         insertCustomer ${CUSTID} ${CUSTNAME} ${CUSTEMAIL}
                                         #echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customers.db
                                         echo "customer ${CUSTID} saved.."
                                      fi
                                      fi
                                      fi
                                      fi
                                      fi
                                      fi

                        ;;
                "2")
                        if [ ${USERID} -eq 0 ]
                        then
                            PrintErrorMsg "You are not authenticated, please authenticate 1st "
                        else
                            echo "Updating an existing email"   

                           #Read required id to update
                            echo -n "Enter customer ID to update : "
                            read Uid
                           #check for valid integer
                            checkInt ${Uid}
                         if [ ${?} -eq 0 ]
                         then
                            echo "Invalid Integer,Try again"
                           #check for id exists
                         else
                            CheckIdEX ${Uid}
                         if [ ${?} -eq 0 ]
                         then
                              echo "ID not Exist" 
                         else
                           #print details
                            PrintDetails ${Uid} " The Details of this Customer are : "
                                echo ${?}                          
			#ask for confirmation   
                              echo "Are You sure you want to update the email of this customer (Y or N):" 
                              read Ans
                         if [ ${Ans} == "Y" ] || [ ${Ans} == "y" ]
                         then
                                  #ask for new email
                                echo "Enter The New Email:"
                                read UserEmail
                                #check email is valid
                                 checkMail "${UserEmail}"
                                 if [ ${?} -eq 0 ]
                                then
                                 echo "Invalid Email"
                                else
                                 #check email exists 
                                 CheckMailEX ${UserEmail}
                                 if [ ${?} -ne 0 ]
                                 then
                                 echo "Mail Exists"
                                else
                                 #update the email in the file
                                 UpdateEmail ${Uid} "${UserEmail}"
                                [ ${?} -eq 0 ] && echo "Email Updated successfully"     
                        #else
                         # if [ ${Ans} == "N" ] || [ ${Ans} == "n" ]
                        #       echo "cancelled"
          fi

                        fi
                        fi
                        fi
                        fi
                        #fi                     
                        fi
                        ;;
                "3")
                        if [ ${USERID} -eq 0 ]
                        then
                         PrintErrorMsg "You are not authenticated, please authenticate 1st "

                        else
                                echo "Deleting existing user"
                                #Read required ID to delete
                                echo -n "Enter customer ID to Delete : "
                                read Rid
                                #Rid=${1}
                                #check for valid integer
                         checkInt ${Rid}
                        if [ ${?} -eq 0 ]
                        then
                                echo "Invalid Integer,Try again"
                        else
                                # check id exists
                         CheckIdEX ${Rid}
                        if [ ${?} -eq 0 ]
                        then
                                echo "ID not Exist" 
                                else
                                # print details
                         PrintDetails ${Rid} " The Details of this Customer are : "
                                # ask for confirmation    
                                echo "Are You sure you want to delete this customer (Y or N):" 
                                read Ans
                        if [ ${Ans} == "Y" ] || [ ${Ans} == "y" ]
                        then
                                # yes: Delete permanently
                        DeleteUser ${Rid}
                          [ ${?} -eq 0 ] && echo "User Deleted Succefully"
                        fi
                        fi
                        fi
                        fi
                        ;;
                "4")
                        echo -n "Enter Customer ID: "
                        read CUSTID
                        checkInt ${CUSTID}
                        if [ ${?} -eq 0 ]
                        then
                                echo "Invalid Integer,Try again"
                        else

                                CheckIdEX ${CUSTID}
                                if [ ${?} -eq 0 ]
                                then
                                echo "ID not Exist"
                        else
                                queryCustomer ${CUSTID}
                        fi
                        fi
                        ;;
                "5")
                        echo "Thank you, see you later Bye"
                        CONT=0
                        ;;



                *)
                        echo "Inavalid option, try again"
               esac
               done
exit 0


