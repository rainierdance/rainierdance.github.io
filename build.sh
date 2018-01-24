TIMESTAMP=`date +%g.%m%d.%H%M`

dirname=$1
if [ -z "$dirname" ]; then
  echo "Usage: $0 subdir_name_without_slash"
  exit 1
fi

# concat all data files
DATAFILE=$dirname/${dirname}_data.js
if [ -d $dirname/data ]; then
  echo '// ---- DO NOT EDIT ----' >$DATAFILE
  datafiles=`ls $dirname/data`
  for file in $datafiles; do
    cat $dirname/data/$file >>$DATAFILE
  done
fi

TMP=tmp.xml
cat $dirname/gadget_boiler_top.txt >$TMP
cat $dirname/index.html >>$TMP
cat $dirname/gadget_boiler_bottom.txt >>$TMP

# replace IS_GADGET, VERSION, URL
sed -e 's/IS_GADGET = false/IS_GADGET = true/g' $TMP | \
sed -e "s/var VERSION = .*$/var VERSION = \"$TIMESTAMP\";/g" | \
sed -e "s#HREF=\"#HREF=\"http://code.dancecentral.info/$dirname/#" | \
sed -e "s#SRC=\"#SRC=\"http://code.dancecentral.info/$dirname/#" | \
sed -e "/src=\"data/d" | \
sed -e "/localonly/d" | \
sed -e "s#<!--DATA-->#<script type=\"text/javascript\" SRC=\"http://code.dancecentral.info/$DATAFILE\"></script>#" \
> $dirname.xml

rm $TMP
