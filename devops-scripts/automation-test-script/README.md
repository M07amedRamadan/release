# Automation Test MongoDB Container.

This script used to create MongoDB container, creates dump of DevDB, restores the dump to MongoDB and creates user for 3 database of the restored data

## Prerequisites
For this script to work, we will need EC2 with docker installed to be able to run container and GitHub installed using self runner option from our GitHub repository.

## How does it work?

### GitHub 
We need to install GitHub at the machine we will use, the installation starts from GitHub repository from setting of the repository:
Repository >> Settings >> Actions >> Runners.

## How to run it?
You need GitHub workflow with self runner and mongo script:- 
1) create script `mongodb.sh` with execution permission.
2) create Workflow with self runner.
3) Create step as follwing:- 

    ```yaml
      - name: Create MongoDB container
        run: |
          echo "running mongodb container script..."
          sudo bash /root/mongodb.sh #write the absolute path of the scipt inside machine.
    ```
