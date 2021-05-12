# Metabase - Cloud Run

This template explains a methodology to deploy Metabase on Google Cloud Run.

Its purpose is to achieve reduced costs when there are no users interacting with the platform.

Keep in mind stateful functionalities may not work properly (i.e. scheduled tasks).


## Deploying Options

There are two ways to setup the deploy:

- **Scale to zero**: Relevante charges only when users are active, requires a keep alive scheduler.
- **Scale to idle one**: No extra setup but incurs a minimum ~$24 charge per month.


### Common Setup

1\. Clone this template, known that initial pipeline will fail (ignore it).

2\. [Optional] Open `.github/workflows/deploy.yml` to adjust registry and service naming and region to your liking:

```yml
REGISTRY_HOSTNAME: gcr.io
REGISTRY_IMAGE_NAME: ${{ github.event.repository.name }}
CLOUD_RUN_SERVICE_NAME: ${{ github.event.repository.name }}
CLOUD_RUN_REGION: us-east1
```

If you know what you are doing, you may also adjust remaining options:

```yml
CLOUD_RUN_CPU: 1
CLOUD_RUN_MEMORY: 2Gi
CLOUD_RUN_TIMEOUT: 120s
CLOUD_RUN_MAX_INSTANCES: 20
CLOUD_RUN_CONCURRENCY: 250
```

3\. Add the following secrets to your new repository:

- `GCP_SERVICE_ACCOUNT_KEY`: Google Cloud JSON service key with Cloud Run deploy permission
- `GCP_PROJECT`: Google Cloud project id
- `MB_DB_TYPE`: Metabase settings database type
- `MB_DB_DBNAME`: Metabase settings database name
- `MB_DB_PORT`: Metabase settings database port
- `MB_DB_USER`: Metabase settings database username
- `MB_DB_PASS`: Metabase settings database password
- `MB_DB_HOST`: Metabase settings database host

4\. Re-run the failed pipeline job to deploy your service.

5\. Using your browser, navigate to deployed URL.

**Important**: You will notice that metabase setup progress will fail to advance.

This is because Cloud Run throttles CPU when there is no use.

To work around this, you must repeatedly hit "refresh" until it displays the configuration page.

6\. Configure the admin user and you are ready to go!

Now, choose how to keep the service alive.


### Scale to Zero

7\. Open Google Cloud Scheduler and create a new job for:

```
*/5 * * *
GET https://[your-cloud-run-host].app
```

This is enough allow scaling to zero without killing original container, this way you have minimum cost without going through the refresh issue every time.


### Scale to Idle One

7\. Open `.github/workflows/deploy.yml` and add the following line between `timeout` and `max-instances`:

```
--timeout $CLOUD_RUN_TIMEOUT \
--min-instances=1 \
--max-instances $CLOUD_RUN_MAX_INSTANCES \
```

8\. Push your changes to redeploy the services.

Now there shall always be one warm instance ready to go preventing scaling to zero and bringing the refresh issue again.


## Local Testing

You may follow these instructions to locally test your metabase:

1\. Create a `.env` file with the following content (adjust accordingly):

```
MB_DB_TYPE=
MB_DB_DBNAME=
MB_DB_PORT=
MB_DB_USER=
MB_DB_HOST=
MB_DB_PASS=
```

2\. Build and execute the image:

```
docker build -t metabase-test .
docker run -it --env-file ./.env -p 3000:3000 metabase-test
```
