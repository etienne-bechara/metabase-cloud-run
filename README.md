# Metabase - Cloud Run

This template explains a methodology to deploy Metabase on Google Cloud Run.

Its purpose is to achieve scale to zero, therefore reducing costs when there are no users interacting with the platform.

Keep in mind stateful functionalities may not work properly (i.e. scheduled tasks).


## Deploy Instruction

1\. Clone this template, the initial pipeline shall fail (ignore it).

2\. [Optional] Open `.github/workflows/deploy.yml` to adjust registry, service name and region according to your liking.

By default it will be set to `gcr.io`, `github.event.repository.name` and `us-east1`:

```yml
REGISTRY_HOSTNAME: gcr.io
REGISTRY_IMAGE_NAME: ${{ github.event.repository.name }}
CLOUD_RUN_SERVICE_NAME: ${{ github.event.repository.name }}
CLOUD_RUN_REGION: us-east1
```

3\. Add the following secrets to your new repository:

- `GCP_SERVICE_ACCOUNT_KEY`: Google Cloud JSON service key with Cloud Run deploy permission
- `GCP_PROJECT`: Google Cloud project id
- `MB_HOST`: Metabase host
- `MB_DB_TYPE`: Metabase DB type
- `MB_DB_HOST`: Metabase DB host
- `MB_DB_PORT`: Metabase DB port
- `MB_DB_DBNAME`: Metabase DB name
- `MB_DB_USER`: Metabase DB username
- `MB_DB_PASS`: Metabase DB password

4\. Re-run the failed pipeline job to deploy your service.

5\. Using your browser, navigate to deployed URL.


## Local Testing

You may follow these instructions to locally test your metabase:

1\. Create a `.env` file with the following content (adjust accordingly).

The example below supposes a MySQL server with a database named `metabase` running on local machine.

```
MB_DB_TYPE=mysql
MB_DB_HOST=host.docker.internal
MB_DB_PORT=3306
MB_DB_DBNAME=metabase
MB_DB_USER=root
MB_DB_PASS=
```

2\. Build and execute the image:

```
docker build -t metabase-test .
docker run -it --env-file ./.env -p 3000:3000 metabase-test
```
