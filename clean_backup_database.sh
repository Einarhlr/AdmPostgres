
fecha_actual=`date +%Y-%m-%d`

#fecha_ultimo_dia_mes_anterior=`date -d "$(date -d $fecha_actual +%Y-%m-01) -1 day" +%d-%m-%Y`

fecha_ultimo_dia_mes_anterior="14-05-2024"

nombre_backup=`ls -th $1.$fecha_ultimo_dia_mes_anterior*.dump | head -1`

/usr/pgsql-14/bin/pg_restore -U postgres --no-owner --no-privileges -s -v -f dump_only_schema_"$nombre_backup".sql $nombre_backup

### EXTENSIONES

sed -i '/EXTENSION.*pg\_repack/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*plpython3u/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*dblink/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*pg\_qualstats/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*pgstattuple/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*pg\_stat\_statements/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*postgres\_fdw/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*tablefunc/d' dump_only_schema_"$nombre_backup".sql
sed -i '/EXTENSION.*unaccent/d' dump_only_schema_"$nombre_backup".sql

### FUNCIONES

begin_f=`egrep -in "CREATE FUNCTION|REPLACE FUNCTION" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

end_f=$((`egrep -n "CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-1))

if ! [ -z $begin_f ] && ! [ -z $end_f ];
then 
	if [ $begin_f -lt $end_f ];
	then
			sed -i $begin_f,"$end_f"d dump_only_schema_"$nombre_backup".sql
	fi
fi

cont_f=`egrep "CREATE FUNCTION|REPLACE FUNCTION" dump_only_schema_"$nombre_backup".sql | wc -l`

i_cont=1

while [ $cont_f -gt 0 ]; 
do	
	i_cont=$((i_cont+1))
	
	begin_f=`egrep -n "CREATE FUNCTION|REPLACE FUNCTION" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`
	
	end_f=$((`egrep -n "CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -$i_cont | tail -1 | cut -d ":" -f 1`-1))
	
	if [ $begin_f -lt $end_f ];
	then
			sed -i $begin_f,"$end_f"d dump_only_schema_"$nombre_backup".sql
	fi

	cont_f=`egrep "CREATE FUNCTION|REPLACE FUNCTION" dump_only_schema_"$nombre_backup".sql | wc -l`
done

### NUC_BITACORA

begin_ft=`egrep -n "CREATE FOREIGN TABLE" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

end_ft=$((`egrep -n "ALTER TABLE ONLY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-1))

if ! [ -z $begin_ft ] && ! [ -z $end_ft ];
then 
	if [ $begin_ft -lt $end_ft ];
	then
		sed -i $begin_ft,"$end_ft"d dump_only_schema_"$nombre_backup".sql
	fi
fi

cont_ft=`egrep "CREATE FOREIGN TABLE" dump_only_schema_"$nombre_backup".sql | wc -l`

i_cont=1

while [ $cont_ft -gt 0 ];
do
        i_cont=$((i_cont+1))
        
		begin_ft=`egrep -n "CREATE FOREIGN TABLE" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

        end_ft=$((`egrep -n "ALTER TABLE ONLY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -$i_cont | tail -1 | cut -d ":" -f 1`-1))

		if [ $begin_ft -lt $end_ft ];
		then
				sed -i $begin_ft,"$end_ft"d dump_only_schema_"$nombre_backup".sql
		fi
        cont_ft=`egrep "CREATE FOREIGN TABLE" dump_only_schema_"$nombre_backup".sql | wc -l`
done

### VISTAS

begin_v=`egrep -n "CREATE VIEW|REPLACE VIEW" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

end_v=$((`egrep -n "ALTER TABLE ONLY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-1))

if ! [ -z $begin_v ] && ! [ -z $end_v ];
then 
	if [ $begin_v -lt $end_v ];
	then
		sed -i $begin_v,"$end_v"d dump_only_schema_"$nombre_backup".sql
	fi
fi

cont_v=`egrep "CREATE VIEW|REPLACE VIEW" dump_only_schema_"$nombre_backup".sql | wc -l`

i_cont=1

while [ $cont_v -gt 0 ];
do
        i_cont=$((i_cont+1))
        begin_v=`egrep -n "CREATE VIEW|REPLACE VIEW" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

        end_v=$((`egrep -n "ALTER TABLE ONLY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -$i_cont | tail -1 | cut -d ":" -f 1`-1))

		if ! [ -z "$begin_v" ] && ! [ -z "$end_v" ];
		then 
			if [ $begin_v -lt $end_v ];
			then
				sed -i $begin_v,"$end_v"d dump_only_schema_"$nombre_backup".sql
			fi
		fi
        cont_v=`egrep "CREATE VIEW|REPLACE VIEW" dump_only_schema_"$nombre_backup".sql | wc -l`
done

### DISPARADORES

begin_t=`egrep -n "CREATE TRIGGER|REPLACE TRIGGER" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`

end_t=$((`egrep -n "FOREIGN KEY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-2))

if ! [ -z $begin_t ] && ! [ -z $end_t ];
then 
	if [ $begin_t -lt $end_t ];
	then
		sed -i $begin_t,"$end_t"d dump_only_schema_"$nombre_backup".sql
	fi
fi

cont_t=`egrep "CREATE TRIGGER|REPLACE TRIGGER" dump_only_schema_"$nombre_backup".sql | wc -l`

i_cont=1

while [ $cont_t -gt 0 ];
do
	i_cont=$((i_cont+1))
	begin_t=`egrep -n "CREATE TRIGGER|REPLACE TRIGGER" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`
	
	end_t=$((`egrep -n "FOREIGN KEY|CREATE TABLE.*\ \(.*" dump_only_schema_"$nombre_backup".sql | head -$i_cont | tail -1 | cut -d ":" -f 1`-2))
	
	if [ $begin_t -lt $end_t ];
	then
			sed -i $begin_t,"$end_t"d dump_only_schema_"$nombre_backup".sql
	fi
	cont_t=`egrep "CREATE TRIGGER|REPLACE TRIGGER" dump_only_schema_"$nombre_backup".sql | wc -l`
done


### FOREIGN KEYS

begin_fk=$((`egrep -n "FOREIGN KEY" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-1))

end_fk=$((`egrep -n "PostgreSQL database dump complete" dump_only_schema_"$nombre_backup".sql | head -1 | cut -d ":" -f 1`-4))

echo "SED FOREIGN KEY"
if ! [ -z $begin_fk ] && ! [ -z $end_fk ];
then 
	if [ $begin_fk -gt 0 ] && [ $end_fk -gt 0 ];
	then
		if [ $begin_fk -lt $end_fk ];
			then
				sed -i $begin_fk,"$end_fk"d dump_only_schema_"$nombre_backup".sql
		fi
	fi
fi

### RESTAURACIÓN DE DATOS

/usr/pgsql-14/bin/pg_restore -U postgres --no-owner --no-privileges -a -v -f dump_only_data_"$nombre_backup".sql $nombre_backup

### PREPARACIÓN DEL BACKUP COMPLETO

tar cfz dump_$nombre_backup.tar.gz dump_only_schema_"$nombre_backup".sql dump_only_data_"$nombre_backup".sql

rm -rf dump_only_schema_"$nombre_backup".sql dump_only_data_"$nombre_backup".sql
