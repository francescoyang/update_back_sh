#!/bin/sh

#############################################
#											#
#	name		:	backup file             #
#	author		:	acanoe					#
# 	timedate	:	2012_11_9  13:50		#
#   versions	:	0.1						#
#											#
#############################################

judge_your_input()
{
	if [ -z $1 ] ;  then
		echo "please input your updatedir!"
		echo ""
		echo "example:"
		echo "./back_file /backdir /updatedir"
		echo "like this example"
		echo ""
		exit
	fi

	if [ -z $2 ] ; then
		echo "please input your backdir!"
		echo ""
		echo "example:"
		echo "./back_file /backdir /updatedir"
		echo "like this example"
		echo ""
		exit
	fi
}

clear_record()
{
	if [ -e ./list_file/old_time_ioc ] ; then
		rm ./list_file/old_time_ioc
	fi
	
	if [ ! -e ./list_file/new_time_ioc ] ;  then
			echo "create a new_time_ioc"
			touch ./list_file/new_time_ioc
	fi

	if [ -e ./list_file/new_time_ioc ] ;  then
		mv  ./list_file/new_time_ioc ./list_file/old_time_ioc
		else
			touch ./list_file/old_time_ioc
	fi

}


find_change_file()
{
	ls $1   > ./list_file/update_file_list
	ls $2   > ./list_file/back_file_list

	while read line
	do      
		R=$(echo $line)
		echo "$R `stat $1/$R  | sed -n '7p'`" >> ./list_file/new_time_ioc
	

	if [ ! -e ./list_file/new_time_ioc ] ;  then
			echo "create a new_time_ioc"
			touch ./list_file/new_time_ioc
	fi
	done < ./list_file/update_file_list

#	while read line
#	do      
#		R=$(echo $line)
#		echo "$R `stat $2/$R  | sed -n '7p'`" >> ./list_file/old_time_ioc
#		echo "$R"
#	done < ./list_file/back_file_list

	diff ./list_file/new_time_ioc ./list_file/old_time_ioc  > ./list_file/diff_file
	sed -n '/</p' ./list_file/diff_file > ./list_file/file
	sed -e 's/< //g' ./list_file/file   > ./list_file/the_file
	sed -e 's/< //g' ./list_file/file   > ./list_file/the_file
}

back_back_file()
{
	while read line
	do      
		R=$(echo $line  | sed -e 's/ .*//g')
		echo $R
		cp $1/$R $2
	done < ./list_file/the_file
}

find_not_exist()
{
	ls $1   > ./list_file/file_list
	ls $2	> ./list_file/back_list
	diff ./list_file/file_list ./list_file/back_list  > ./list_file/diff_file
	sed -n '/</p' ./list_file/diff_file > ./list_file/file
	sed -e 's/< //g' ./list_file/file  > ./list_file/the_file
	while read line
	do      
		R=$(echo $line)
		echo $R
		cp -rf $1/$R $2 
	done < ./list_file/the_file
}




judge_your_input $1 $2
clear_record 
find_change_file $1  $2
back_back_file $1 $2
find_not_exist $1 $2


