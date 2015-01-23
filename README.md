# Conjur Secrets Demo

This demo shows how to securely provide infrastructure secrets (in this case, a database password), 
to an application running in Docker. 

# Docker Images

## conjur-redmine-db

A MySQL database. 

## conjur-redmine-insecure

The Redmine application, with the database password hard-coded into the Dockerfile.

## conjur-redmine-conjurenv

The Redmine application, with the database password provided by [conjur env run](http://developer.conjur.net/reference/tools/conjurenv/run.html).

# Running The Demo

Build the images:

    $ make

Run the database container:

    $ docker run --name=conjur-redmine-db -d conjur-redmine-db

Obtain the database hostname:

    $ mysql_host=`docker inspect conjur-redmine-db | grep IPAddress | cut -d '"' -f 4`

Run the insecure Redmine application:

    $ docker run -it --rm -e DB_HOST=$mysql_host -p 8080:80 redmine-insecure
    
Open Redmine in the browser:

**Linux**

    $ open http://localhost:8080

**Boot2Docker**

    $ open http://$(boot2docker ip):8080

Shut down Redmine with `Ctrl-C`.

Load the policy file:

    $ conjur policy load -c policy.json policy.rb

Run the secure Redmine:

    $ docker run -it --rm -e POLICY_ID=`cat policy.json | jsonfield policy` \
      -e CONJUR_ACCOUNT=dev \
      -e CONJUR_APPLIANCE_URL=https://conjur-dev.conjur.net/api \
      -e DB_HOST=$mysql_host \
      -p 8080:80 \
      conjur-redmine-conjurenv
