## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


import subprocess
import re
import os
import glob

# NOTE:  Need to harden all the string processing code below.  This will include:
# --- startIndex calculated programatically for each split of a string
# Consolidate the functions to become more polymorphic.

ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')

cidr_subnet_acm = ''
cidr_subnet_list_acm = []
security_group_id_acm_nodes = ''
vpc_id_acm = ''
route_table_id_acm_host = ''
internet_gateway_acm_host = ''
cidr_subnet_acm_id = ''

def checkForErrors(myDecodedLine):
    foundAnExceptionWorthStoppingScript="no"
    if "connectex: No connection could be made because the target machine actively refused it." in myDecodedLine:
        foundAnExceptionWorthStoppingScript="yes"
    if "Error launching source instance: InvalidGroup.NotFound: The security group" in myDecodedLine:
        #This might require special retry logic instead of simply stopping the script as we are doing now.
        foundAnExceptionWorthStoppingScript="yes"
    if foundAnExceptionWorthStoppingScript=="yes":
        print("                                           ")
        print("---- Stopping script due to error. ----")
        print("                                           ")
        exit(1)

def deployAgileCloudManagerHostNetwork( scriptName, workingDir ):
    print("scriptName is: " +scriptName)
    print("workingDir is: " +workingDir)
    proc = subprocess.Popen( scriptName,cwd=workingDir,stdout=subprocess.PIPE, shell=True)
    inCidrBlock='false'
    while True:
      line = proc.stdout.readline()
      if line:
        thetext=line.decode('utf-8').rstrip('\r|\n')
        decodedline=ansi_escape.sub('', thetext)
        checkForErrors(decodedline)
        print(decodedline)
        if "Outputs:" in decodedline:  
          print("JENGA")
        global cidr_subnet_list_acm
        if "cidr_subnet_acm" in decodedline:  
            print("decodedline is: "+decodedline)
            if not "[" in decodedline:  
                global cidr_subnet_acm
                cidr_subnet_acm = decodedline[22:]
                cidr_subnet_line_test = re.findall("(?:\d{1,3}\.){3}\d{1,3}(?:/\d\d?)?",decodedline)
                cidr_subnet_line_test_string = ''.join(cidr_subnet_line_test)
                print("cidr_subnet_line_test_string 'not [' is: "+cidr_subnet_line_test_string)
                numCidrs=len(cidr_subnet_line_test)
                print("numCidrs is: "+str(numCidrs))
                if numCidrs > 0:
                    print("cidr_subnet_line_test[0] is: " +cidr_subnet_line_test[0])
                    cidr_subnet_list_acm.append(cidr_subnet_line_test[0])
                else:
                    print("There are no CIDRs listed in this cidr_subnet_acm line.")
            if "[" in decodedline:  
                inCidrBlock='true'
        elif inCidrBlock=='true':
            if "]" in decodedline:
                inCidrBlock='false'
            if inCidrBlock=='true':
                decodedline=decodedline.strip()
                decodedline=decodedline.replace(",","")
                cidr_subnet_line_test = re.findall("(?:\d{1,3}\.){3}\d{1,3}(?:/\d\d?)?",decodedline)
                if len(cidr_subnet_line_test) == 0:
                    print("cidr_subnet_line_test is EMPTY. ")
                elif len(cidr_subnet_line_test) == 1:
                    print("cidr_subnet_line_test is: " +cidr_subnet_line_test[0])
                    cidr_subnet_list_acm.append(cidr_subnet_line_test[0])
                else:
                    print("UNHANDLED EXCEPTION: cidr_subnet_line_test has multiple entries.")
        if "security_group_id_acm_nodes" in decodedline:  
          print("                                            ")
          print("decodedline is: " +decodedline)
          startIndex = int(decodedline.find('sg-'))
          print("startIndex is: " +str(startIndex))
          print("                                            ")
          global security_group_id_acm_nodes
          security_group_id_acm_nodes = decodedline[startIndex:]
        if "vpc_id_acm" in decodedline:  
          global vpc_id_acm
          vpc_id_acm = decodedline[17:]
        if "route_table_id_acm_host" in decodedline:  
          print("                                            ")
          print("decodedline is: " +decodedline)
          startIndex = int(decodedline.find('rtb-'))
          print("startIndex is: " +str(startIndex))
          print("                                            ")
          global route_table_id_acm_host
          route_table_id_acm_host = decodedline[startIndex:]
        if "internet_gateway_acm_host" in decodedline:  
          print("                                            ")
          print("decodedline is: " +decodedline)
          startIndex = int(decodedline.find('igw-'))
          print("startIndex is: " +str(startIndex))
          print("                                            ")
          global internet_gateway_acm_host
          internet_gateway_acm_host = decodedline[startIndex:]
        if "cidr_subnet_acm_id" in decodedline:  
          print("                                            ")
          print("decodedline is: " +decodedline)
          startIndex = int(decodedline.find('subnet-'))
          print("startIndex is: " +str(startIndex))
          print("                                            ")
          global cidr_subnet_acm_id
          cidr_subnet_acm_id = decodedline[startIndex:]
      else:
        break

def removeAgileCloudManagerHostNetwork( scriptName, workingDir ): 
    proc = subprocess.Popen( scriptName,cwd=workingDir,stdout=subprocess.PIPE, shell=True)
    while True:
      line = proc.stdout.readline()
      if line:
        thetext=line.decode('utf-8').rstrip('\r|\n')
        decodedline=ansi_escape.sub('', thetext)
        print(decodedline)
        if "Outputs:" in decodedline:  
          print("Outputs are: ")
      else:
        break
