#!/bin/bash

MYSQL_PWD="--ZBX_MYSQL_CHECK_PASS--"
PARAM="-u--ZBX_MYSQL_CHECK_USER-- -p$MYSQL_PWD -P $2 -h 127.0.0.1"
MYSQLADMIN="/usr/bin/mysqladmin"
MYSQL="/usr/bin/mysql"

case "$1" in
     Ping)
               $MYSQLADMIN $PARAM ping 2>/dev/null|grep alive|wc -l
               ;;
     Threads)
               $MYSQLADMIN $PARAM status 2>/dev/null|cut -f3 -d":"|cut -f1 -d"Q"
               ;;
     Questions)
               $MYSQLADMIN $PARAM status 2>/dev/null|cut -f4 -d":"|cut -f1 -d"S"|awk '{printf("%1.2f",$1)}'
               ;;
     Slow_queries)
               $MYSQLADMIN $PARAM status 2>/dev/null|cut -f5 -d":"|cut -f1 -d"O"
               ;;
     Qps)
               $MYSQLADMIN $PARAM status 2>/dev/null|cut -f9 -d":"
               ;;
     Slave_IO_State)
               if [ "$($MYSQL $PARAM -e "show slave status\G" 2>/dev/null| grep Slave_IO_Running:|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi
               ;;
     Slave_SQL_State)
               if [ "$($MYSQL $PARAM -e "show slave status\G" 2>/dev/null| grep Slave_SQL_Running:|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi
               ;;
     Key_buffer_size)
               $MYSQL $PARAM -e "show variables like 'key_buffer_size';"  2>/dev/null| grep -v Value |awk '{print $2/1024^2}'
               ;;
     Key_reads)
               $MYSQL $PARAM -e "show global status like 'key_reads';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Key_read_requests)
               $MYSQL $PARAM -e "show global status like 'key_read_requests';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Key_cache_miss_rate)
               echo $($MYSQL $PARAM -e "show global status like 'key_reads';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'key_read_requests';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Key_blocks_used)
               $MYSQL $PARAM -e "show global status like 'key_blocks_used';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Key_blocks_unused)
               $MYSQL $PARAM -e "show global status like 'key_blocks_unused';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Key_blocks_used_rate)
               echo $($MYSQL $PARAM -e "show global status like 'key_blocks_used';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'key_blocks_unused';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/($1+$2)*100)}'
               ;;
     Innodb_buffer_pool_size)
               $MYSQL $PARAM -e "show variables like 'innodb_buffer_pool_size';" 2>/dev/null| grep -v Value |awk '{print $2/1024^2}'
               ;;
     Innodb_log_file_size)
               $MYSQL $PARAM -e "show variables like 'innodb_log_file_size';" 2>/dev/null| grep -v Value |awk '{print $2/1024^2}'
               ;;
     Innodb_log_buffer_size)
               $MYSQL $PARAM -e "show variables like 'innodb_log_buffer_size';" 2>/dev/null| grep -v Value |awk '{print $2/1024^2}'
               ;;
     Table_open_cache)
               $MYSQL $PARAM -e "show variables like 'table_open_cache';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Open_tables)
               $MYSQL $PARAM -e "show global status like 'open_tables';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Opened_tables)
               $MYSQL $PARAM -e "show global status like 'opened_tables';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Open_tables_rate)
               echo $($MYSQL $PARAM -e "show global status like 'open_tables';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM  -e "show global status like 'opened_tables';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/($1+$2)*100)}'
               ;;
     Table_open_cache_used_rate)
               echo $($MYSQL $PARAM -e "show global status like 'open_tables';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show variables like 'table_open_cache';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/($1+$2)*100)}'
               ;;
     Thread_cache_size)
               $MYSQL $PARAM -e "show variables like 'thread_cache_size';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Threads_cached)
               $MYSQL $PARAM -e "show global status like 'Threads_cached';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Threads_connected)
               $MYSQL $PARAM -e "show global status like 'Threads_connected';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;; 
     Threads_created)
               $MYSQL $PARAM -e "show global status like 'Threads_created';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Threads_running)
               $MYSQL $PARAM -e "show global status like 'Threads_running';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_free_blocks)
               $MYSQL $PARAM -e "show global status like 'Qcache_free_blocks';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_free_memory)
               $MYSQL $PARAM -e "show global status like 'Qcache_free_memory';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_hits)
               $MYSQL $PARAM -e "show global status like 'Qcache_hits';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_inserts)
               $MYSQL $PARAM -e "show global status like 'Qcache_inserts';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_lowmem_prunes)
               $MYSQL $PARAM -e "show global status like 'Qcache_lowmem_prunes';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;; 
     Qcache_not_cached)
               $MYSQL $PARAM -e "show global status like 'Qcache_not_cached';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_queries_in_cache)
               $MYSQL $PARAM -e "show global status like 'Qcache_queries_in_cache';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_total_blocks)
               $MYSQL $PARAM -e "show global status like 'Qcache_total_blocks';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Qcache_fragment_rate)
               echo $($MYSQL $PARAM -e "show global status like 'Qcache_free_blocks';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'Qcache_total_blocks';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Qcache_used_rate)
               echo $($MYSQL $PARAM -e "show variables like 'query_cache_size';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'Qcache_free_memory';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",($1-$2)/$1*100)}'
               ;;
     Qcache_hits_rate)
               echo $($MYSQL $PARAM -e "show global status like 'Qcache_hits';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'Qcache_inserts';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{if($1==0){print "0"}else{printf("%1.4f\n",($1-$2)/$1*100)}}'
               ;;
     Query_cache_limit)
               $MYSQL $PARAM -e "show variables like 'query_cache_limit';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Query_cache_min_res_unit)
               $MYSQL $PARAM -e "show variables like 'query_cache_min_res_unit';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Query_cache_size)
               $MYSQL $PARAM -e "show variables like 'query_cache_size';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Sort_merge_passes)
               $MYSQL $PARAM -e "show global status like 'Sort_merge_passes';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Sort_range)
               $MYSQL $PARAM -e "show global status like 'Sort_range';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Sort_rows)
               $MYSQL $PARAM -e "show global status like 'Sort_rows';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Sort_scan)
               $MYSQL $PARAM -e "show global status like 'Sort_scan';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_first)
               $MYSQL $PARAM -e "show global status like 'Handler_read_first';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_key)
               $MYSQL $PARAM -e "show global status like 'Handler_read_key';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_next)
               $MYSQL $PARAM -e "show global status like 'Handler_read_next';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_prev)
               $MYSQL $PARAM -e "show global status like 'Handler_read_prev';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_rnd)
               $MYSQL $PARAM -e "show global status like 'Handler_read_rnd';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Handler_read_rnd_next)
               $MYSQL $PARAM -e "show global status like 'Handler_read_rnd_next';" 2>/dev/null| grep -v Value |awk '{print $2}' 
               ;;
     Com_select)
               $MYSQL $PARAM -e "show global status like 'com_select';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_insert)
               $MYSQL $PARAM -e "show global status like 'com_insert';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_insert_select)
               $MYSQL $PARAM -e "show global status like 'com_insert_select';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_rollback)
               $MYSQL $PARAM -e "show global status like 'Com_rollback';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_begin)
               $MYSQL $PARAM -e "show global status like 'Com_begin';" 2>/dev/null| grep -v Value |awk '{print $2}'     
               ;;
     Com_commit)
               $MYSQL $PARAM -e "show global status like 'Com_commit';" 2>/dev/null| grep -v Value |awk '{print $2}'   
               ;;
     Com_update)
               $MYSQL $PARAM -e "show global status like 'com_update';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_delete)
               $MYSQL $PARAM -e "show global status like 'Com_delete';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_replace)
               $MYSQL $PARAM -e "show global status like 'com_replace';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Com_replace_select)
               $MYSQL $PARAM -e "show global status like 'com_replace_select';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Table_scan_rate)
               echo $($MYSQL $PARAM -e "show global status like 'Handler_read_rnd_next';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'com_select';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Open_files)
               $MYSQL $PARAM -e "show global status like 'open_files';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Open_files_limit)
               $MYSQL $PARAM -e "show variables like 'open_files_limit';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Open_files_rate)
               echo $($MYSQL $PARAM -e "show global status like 'open_files';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show variables like 'open_files_limit';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Created_tmp_disk_tables)
               $MYSQL $PARAM -e "show global status like 'created_tmp_disk_tables';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Created_tmp_tables)
               $MYSQL $PARAM -e "show global status like 'created_tmp_tables';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Created_tmp_disk_tables_rate)
               echo $($MYSQL $PARAM -e "show global status like 'created_tmp_disk_tables';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'created_tmp_tables';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Max_connections)
               $MYSQL $PARAM -e "show variables like 'max_connections';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Max_used_connections)
               $MYSQL $PARAM -e "show global status like 'Max_used_connections';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Max_connections_used_rate)
               echo $($MYSQL $PARAM -e "show global status like 'Max_used_connections';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show variables like 'max_connections';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
               ;;
     Table_locks_immediate)
               $MYSQL $PARAM -e "show global status like 'Table_locks_immediate';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Table_locks_waited)
               $MYSQL $PARAM -e "show global status like 'table_locks_waited';" 2>/dev/null| grep -v Value |awk '{print $2}'
               ;;
     Engine_select)
               echo $($MYSQL $PARAM -e "show global status like 'Table_locks_immediate';" 2>/dev/null| grep -v Value |awk '{print $2}') $($MYSQL $PARAM -e "show global status like 'table_locks_waited';" 2>/dev/null| grep -v Value |awk '{print $2}')| awk '{if($2==0){print "0"}else{printf("%5.4f\n",$1/$2)}}'
		;;
     wsrep_incoming_addresses)
               $MYSQL $PARAM -e "show global status like 'wsrep_incoming_addresses';" 2>/dev/null|grep -v Value|awk '{print $2}'
                ;;
     wsrep_cluster_status)
               $MYSQL $PARAM -e "show global status like 'wsrep_cluster_status';" 2>/dev/null|grep -v Value|awk '{print $2}'
                ;;
    wsrep_local_state_comment)
              $MYSQL $PARAM -e "show global status like 'wsrep_local_state_comment';" 2>/dev/null|grep -v Value|awk '{print $2}'
                ;;
    wsrep_cluster_size)
              $MYSQL $PARAM -e "show global status like 'wsrep_cluster_size';" 2>/dev/null|grep -v Value|awk '{print $2}'
                ;;
    wsrep_ready)
              $MYSQL $PARAM -e "show global status like 'wsrep_ready';" 2>/dev/null|grep -v Value|awk '{print $2}'
                ;;

esac
