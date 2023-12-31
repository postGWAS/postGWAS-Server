# postGWAS-Server

This web server makes it very easy for the users to carry out the postGWAS analysis without the need to download the appropriate software and configuring the relevant environment. In summary, nine methods can be used to calculate causal genes or causal variants, including FUSION, CAVIAR, CAVIARBF, PAINTOR, FINEMAP, eCAVIAR, coloc, fastENLOC, and S-PrediXcan.

# Frontend

## Prerequisites:

1. node.js v16.13.0 or above

## Installation instructions:

To run a post-GWAS Server frontend perform the following steps:

1. install node.js
2. clone this project
   ```
   git clone https://github.com/postGWAS/postGWAS-Server.git
   cd postGWAS-Server/frontend
   ```
3. complete the setup process
   ```
    npm install     # Install dependencies
    npm run build:test   # Build the frontend project
    npm run preview     # run the server
   ```
   

# Backend

## Prerequisites:

1. JDK v1.8.0 or above
2. MySQL v8.0 or above

## Installation instructions:

To run a post-GWAS Server frontend perform the following steps:

1. create database tables

   ```
   mysql -u <username> -p <database_name> < schema.sql
   ```

2. clone this project

   ```
   git clone https://github.com/postGWAS/postGWAS-Server.git
   cd postGWAS-Server/backend
   ```

3. run the java program

   ```
   java -jar postGWASServer.jar
   ```
