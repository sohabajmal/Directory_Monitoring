#!/bin/bash
flag=0
declare -a previous_files_hash
declare -a filenames
echo Monitoring Directory
#Loop program 
while true
do
   declare -a files_hash
   i=0   
   #Calculate Files Hash Value
   for file in test_folder/*
   do 
      files_hash[i]=`md5sum ${file} | awk '{ print $1 }'`
      filenames[i]=$file
      i=$i+1
   done

   #Compare hash of files and update
   j=0
   k=0
   declare -a changed_files_names
   for i in ${files_hash[@]}: 
   do
      if [[ $flag == 1 ]]
      then
         if [[ ${previous_files_hash[j]} != $i ]]
         then
            changed_files_names[k]=${filenames[j]}
           # echo  ${filenames[j]} | sed "s/.*\///"
          fi
      fi
   previous_files_hash[j]=$i
   j=$j+1
   k=$k+1
   done
   #Mail Changings 
   if [[ "${#changed_files_names[@]}" -gt 0 ]]
   then
      (echo Files Changed at time $(date +"%r")
       for i in ${changed_files_names[@]}: 
       do
          echo $i | sed "s/.*\///"  
       done )| mail -s "Content Changed in Directory"      sohaib@localhost
   echo $(date +"%r")  ${#changed_files_names[@]} Files Changed, Admin  Notified
   unset changed_files_names
    fi

flag=1
sleep 3m
done
