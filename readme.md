# BlockArena
Networking / Multiplayer example for Kha. It demonstrates the general network setup, replicated variables which are automatically sychronized between the clients (with the server being in charge in case of conflicts), manual RPCs (server only or on all clients), object ownership via session.me.id as well as the ping measurement.

Note that the same code is run both on the server and on all clients while Kha handles the synchronization, so there is no client- or server-specific code in BlockArena itself.

# Running the example
Currently, networking is only supported in the html5 backend (for the clients) and requires a dedicated node.js server.

## First time setup
Build the server with `node Kha/make node`, then navigate to "build/node" and run `npm install`.

## Testing
Build the **server** with `node Kha/make node`, then navigate to "build/node" and start the server with `node kha.js`.

Build the **client** with `node Kha/make html5`, then open the index.html in "build/html5" twice (the example requires two clients).

## Debugging
To debug the **client**, just run the project from KodeStudio like you would with any other Kha project.

To debug the **server**, open the folder "build/node" in KodeStudio.

Naturally, you need to run the other client / server in addition to that. If you are on windows you can just run my testscript (*_test.bat*). It compiles both backends, starts the server and opens one client with your default browser. Then you can start debugging the client in KodeStudio right away.
