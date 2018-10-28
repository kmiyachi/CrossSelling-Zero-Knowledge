# Cross Selling Application: ZoKrates Implementation

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

- A CSV has been provided that has the VIP Scores of each user 'vip_scores.csv'
- Input the VIP Score value of for a given user
- Press the 'Verify VIP Score' Button to confirm wether the inputted VIP Score is correct or not (You can test incorrect VIP scores)
- Send the transaction through via Metamask
- Determine if the VIP Score is accurate or not from the verified field for each user
- private_bank_info.csv contains the private information that bank would only have access to to compute the witness and generate the proofs
- in the 'code' directory is the basic algorithm used to deterine VIP Score
