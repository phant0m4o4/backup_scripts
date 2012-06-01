#!/bin/bash
#backup.sh
#备份至/root/bak/

##################################################
#保留天数
RetainDay=30
#日志目录
LogPath=/backup/log
#备份目录
BackupPath=/backup/data
#需要备份的文件列表 项目名不能重复 使用绝对路径
#格式
#ProjectName1:ProjectPath1
#ProjectName2:ProjectPath2
ProjectLst=/backup/filebackup.lst 
##################################################
DATE=`date +"%Y-%m-%d-%H-%M-%S"`
LogFile=$LogPath/`date +"%Y-%m"`.log

if [ ! -d $LogPath ]
then
	mkdir -p $LogPath
fi

if [ ! -d $BackupPath ]
then
	mkdir -p $BackupPath
fi

echo "backup start at $(date +"%Y-%m-%d %H:%M:%S")" >>$LogFile

PROJECTLIST=`cat $ProjectLst`
for Project in $PROJECTLIST
do
	echo "start backup $Project" >>$LogFile
	ProjectName=''
	ProjectPath=''
	ProjectName=${Project%%':'*}
	ProjectPath=${Project#*':'}

	ProjectData=$ProjectPath
	DestPath=$BackupPath/$DATE.$ProjectName
	PackFile=$BackupPath/$DATE.$ProjectName.tgz
	if [ -f $BackupPath/$PackFile ]
	then
		echo "backup file have exist !" >>$LogFile
	else
		echo "copy file to dest path:"$DestPath >>$LogFile
		cp -RHpf $ProjectData $DestPath  >>$LogFile
		echo "tar file $PackFile from $DestPath" >>$LogFile
		tar -C $DestPath -zcf $PackFile `ls -A $DestPath`>>$LogFile
		echo "backup $Project into $PackFile done" >>$LogFile
		rm -rf $DestPath
	fi
find $BackupPath -type f -mtime +$RetainDay -name "*.$ProjectName.tgz" -exec rm {} \; >>$LogFile
done


echo "backup end at $(date +"%Y-%m-%d %H:%M:%S")" >>$LogFile
echo " " >> $LogFile
exit 0