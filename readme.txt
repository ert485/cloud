directories:
  - cloud_init
    - user data files that can be loaded on vm setups (e.g. digital ocean droplets, vultr instances)
    - they can reference files in starting_files (using curl)
  - starting_files
    - files that were too long to easily put in a cloud_init user data file
