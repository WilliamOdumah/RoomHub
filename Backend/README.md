# RoomHub

## Backend Quickstart
No need to host the backend manually. It is hosted on aws lambda.
If lambda doesn't work:
1. Make sure `node` , `npm` and `java` are installed.To check:
    ```
    $ node -v
    $ npm -v
    $ java -version
    ```
    - Go to [https://nodejs.org/en/download/](https://nodejs.org/en/download/) to download the installer.
    - Go to [Java windows installation guide](https://www.youtube.com/watch?app=desktop&v=jPwrWjEwtrw) , [Java Mac installation guide](https://www.youtube.com/watch?v=PQk9O03cukQ) to install java
2. Go to the backend directory.
    ```
    $ cd Backend
    ```
3. Install dependencies.
    ```
    $ npm install
    ```
    - Update `npm` if necessary.
4. Run the server.
    ```
    $ node src/index.js
    ```

## Backend Testing
1. Make sure `node` , `npm` and `java` are installed. To check:
    ```
    $ node -v
    $ npm -v
    $ java -version
    ```
    - Go to [https://nodejs.org/en/download/](https://nodejs.org/en/download/) to download the installer.
    - Go to [Java windows installation guide](https://www.youtube.com/watch?app=desktop&v=jPwrWjEwtrw) , [Java Mac installation guide](https://www.youtube.com/watch?v=PQk9O03cukQ) to install java
2. Go to the backend directory.
    ```
    $ cd Backend
    ```
3. Install dependencies.
    ```
    $ npm install
    ```
    - Update `npm` if necessary.
4. Run all tests.
    ```
    $ npm run test
    ```
5. Run Unit tests.
   ```
   $ npm run unit-test
    ```
6. Run Integration tests.
   ```
   $npm run integration-test
   ```

## Backend Documentation
1. Go to the backend directory.
    ```
    $ cd Backend/docs/index.html
    ```
2. Open the index.html file in Browser
3. API specification under the Namespaces group. User,Room and Notification are the current base paths we have.
4. Other documentation for classes in Modules and Classes
