## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

def validateAgileCloudManagerHostNetwork(cidr_sub_acm, cidr_sub_list_acm, sg_id_acm_nodes, vpcid_acm, route_tbl_id_acm_host):
    success='true'
    print('                                          ')
    print('----------------------------------------- ')
    print('---- Validating Agile Cloud Manager Host Network ---- ')
    print('cidr_subnet_acm is: ' +cidr_sub_acm)
    print('cidr_subnet_list_acm is: ')
    print(cidr_sub_list_acm)
    print('security_group_id_acm_nodes is: ' +sg_id_acm_nodes)
    print('vpc_id_acm is: ' +vpcid_acm)
    print('route_table_id_acm_host is: ' +route_tbl_id_acm_host)

    if cidr_sub_acm == '':
        print('Exiting because cidr_subnet_acm is empty.')
        success='false'
    if not cidr_sub_list_acm:  
        print('Exiting because cidr_subnet_list_acm is empty.')
        success='false'
    if sg_id_acm_nodes == '':
        print('exiting because security_group_id_acm_nodes is empty.')
        success='false'
    if vpcid_acm == '':
        print('Exiting because vpc_id_acm is empty.')
        success='false'
    if route_tbl_id_acm_host == '':
        print("Exiting because route_table_acm_host is empty.")
        success='false'
    if success=='false':
        print('About to exit 1 from validateAgileCloudManagerHostNetwork.')
        exit(1)
    else:  
        print('SUCCESS validateAgileCloudManagerHostNetwork.')
