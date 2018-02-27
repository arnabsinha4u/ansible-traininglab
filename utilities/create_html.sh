#!/bin/bash

#Variables
logo_to_be_used="${logo_to_be_used:-Ansible_Logo.png}"
path_of_html_and_logo="${path_of_html_and_logo:-/var/www/html/}"
html_file_name="${html_file_name:-index.html}"
cnt_master=${1:-1}
cnt_slaves=${2:-1}

cp utilities/$logo_to_be_used /var/www/html/$logo_to_be_used

header='<h1 style="text-align: center;"><strong>Learning&nbsp;&nbsp;<img src='$logo_to_be_used' alt="" width="100" height="100" /></strong></h1><h3 style="text-align: center;"><strong>Welcome to the Ansible Course</strong></h3><h4 style="text-align: center;">Transform yourself:&nbsp;<a>ip/fqdn in address bar</a></h4><p>Contact: Administrator</p><p>Use your terminal &amp; SSH to: ip/fqdn in address bar (defualt SSH port)</p><hr />'

echo $header > $path_of_html_and_logo/$html_file_name

#Loop var init
masters=1
slaves=1

while [ $masters -le $cnt_master ]
do
    master_ip_address=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' master-$masters`

    per_student_repeater='<p><em><strong>---</strong></em><br /> <em><strong>&nbsp; -- </strong></em>Student '$masters' <br />&nbsp; &nbsp; - Properties<br />&nbsp; &nbsp; &nbsp; &nbsp; Username: ansiblelabuser'$masters'<br />&nbsp; &nbsp; &nbsp; &nbsp; Password: ansiblelabuser'$masters'<br />&nbsp; &nbsp; &nbsp; &nbsp; Control Node: master-'$masters' OR '$master_ip_address' <br />&nbsp; &nbsp; &nbsp; &nbsp; Managed Nodes:<br /> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; with_item:<br />'
    echo $per_student_repeater >> $path_of_html_and_logo/$html_file_name

  while [ $slaves -le $cnt_slaves ]
  do
    slave_ip_address=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' master-$masters-slave-$slaves`

    per_slave_repeater='&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - master-'$masters'-slave-'$slaves' OR '$slave_ip_address'<br />'
    echo $per_slave_repeater >> $path_of_html_and_logo/$html_file_name

    slaves=`expr $slaves + 1`

  done

  echo '<hr />' >> $path_of_html_and_logo/$html_file_name

  slaves=1
  masters=`expr $masters + 1`
done
