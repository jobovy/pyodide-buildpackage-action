FROM pyodide/pyodide-env:20220525-py310-chrome102-firefox100

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]