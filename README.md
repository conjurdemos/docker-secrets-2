# Conjur Secrets Demo

This demo shows how to securely provide infrastructure secrets (in this case, a database password),
to an application running in Docker.

# Docker Images

## docker-secrets-2-db

A MySQL database.

## docker-secrets-2-insecure

The Redmine application, with the database password hard-coded into the Dockerfile.

## docker-secrets-2-secure

The Redmine application, with the database password provided by [conjur env run](http://developer.conjur.net/reference/tools/conjurenv/run.html).

# Running the Demo

Run the database container:

    $ docker run --name=docker-secrets-2-db -d conjurdemos/docker-secrets-2-db

Obtain the database hostname:

    $ mysql_host=`docker inspect docker-secrets-2-db | grep IPAddress | cut -d '"' -f 4`

Run the insecure Redmine application:

    $ docker run -it --rm -e DB_HOST=$mysql_host -p 8080:80 conjurdemos/docker-secrets-2-insecure

Open Redmine in the browser:

**Linux**

    $ xdg-open http://localhost:8080/projects/conjur-secrets-demo/issues

**Boot2Docker**

    $ open http://$(boot2docker ip):8080/projects/conjur-secrets-demo/issues

Shut down Redmine with `Ctrl-C`.

Load the policy file:

    $ CONJURAPI_LOG=stderr conjur policy load -c policy.json policy.rb

`conjurize` the host:

    $ policy_id=`cat policy.json | jsonfield policy`
    $ conjur host create $policy_id/docker/secure | tee host.json | conjurize > conjurize.sh
    $ conjur layer hosts add $policy_id/redmine $policy_id/docker/secure

Run the secure Redmine:

    $ docker run -it --rm \
      -v $PWD/conjurize.sh:/conjurize.sh \
      -e POLICY_ID=$policy_id \
      -e DB_HOST=$mysql_host \
      -p 8080:80 \
      conjurdemos/docker-secrets-2-secure

The startup script in this container will use `conjur env check` to verify that all required secrets:

1) Are populated with a value
2) Can be fetched by the container`

At this point, the database password has not yet been stored in Conjur, so the Redmine container will print
an error and exit.

Load the password into Conjur:

    $ conjur variable values add $policy_id/db-password ZemuBRAXu2tadr

Now, run Redmine again:

    $ docker run -it --rm \
      -v $PWD/conjurize.sh:/conjurize.sh \
      -e POLICY_ID=$policy_id \
      -e DB_HOST=$mysql_host \
      -p 8080:80 \
      conjurdemos/docker-secrets-2-secure

This time, it will start successfully and connect to the database. You can refresh the Redmine
application in your browser, and see that it's running.

Conjur records a detailed audit of system activity. For example, you can print all the events
related to the database password:

    $ conjur audit resource -s variable:$policy_id/db-password
    [2015-01-23 17:51:12 UTC] dev:user:kgilpin checked that they can execute dev:variable:kgilpin@spudling-2.local/docker-secrets-redmine-1.0/db-password (true)
    [2015-01-23 19:52:25 UTC] dev:host:kgilpin@spudling-2.local/docker-secrets-redmine-1.0/container/0 checked that they can execute dev:variable:kgilpin@spudling-2.local/docker-secrets-redmine-1.0/db-password (true)

# Build

Build and push the images:

    $ make
