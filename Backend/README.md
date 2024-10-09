# RoomHub

## Backend Quickstart
No need to host the backend manually. It is hosted on aws lambda.
If lambda doesn't work:
1. Make sure `node` and `npm` are installed. To check:
    ```
    $ node -v
    $ npm -v
    ```
    - Go to [https://nodejs.org/en/download/](https://nodejs.org/en/download/) to download the installer.
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
1. Make sure `node` and `npm` are installed. To check:
    ```
    $ node -v
    $ npm -v
    ```
    - Go to [https://nodejs.org/en/download/](https://nodejs.org/en/download/) to download the installer.
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
   $ npm run unit-tests
    ```
6. Run Integration tests.
   ```
   $npm run integration-tests
   ```