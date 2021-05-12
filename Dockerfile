FROM metabase/metabase
EXPOSE 3000

ENTRYPOINT [ "/app/run_metabase.sh" ]
