# Cross Selling Application: Regular Ethereum Implementation

1. Install dependencies

```
npm i
```

2. Launch Ganache

```
ganache-cli
```

3. Setup Metamask

- Import an account from ganache into metamask
- Switch the network over to LocalHost 8545

4. Migrate Contract onto local network using truffle

```
truffle migrate --reset
```

5. Run the Application

```
npm run dev
```

6. Interact with the Application

- Click on the 'Calculate VIP' button and that will send a transaction to calculate the VIP Score for the given user
- The VIP Score will be displayed in the VIP Score section for each user
