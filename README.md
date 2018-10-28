# Origo_CrossSelling

### Setup

1. Clone the repo

```
git clone https://github.com/kmiyachi/Origo_CrossSelling.git
cd Origo_CrossSelling
```

2. Install global blockchain modules

```
npm i -g truffle
npm i -g ganache-cli
```

### Regular Ethereum Implementation

```
cd public_cs
```

**README for Usage is in the public_cs directory**

### ZoKrates Implementation

```
cd zero_knowledge
```

**README for Usage is in the zero_knowledge directory**

### Proof Generation:

1. Download [Zokrates](https://github.com/JacobEberhardt/ZoKrates) and run pre-built docker instance

```
docker run -ti zokrates/zokrates /bin/bash
```

2. Move into the proper directory

```
cd target/releases
```

3. Compile, Setup, and Export Verifier

```
./zokrates compile -i 'vip.code'
./zokrates setup
./zokrates export-verifier
```

4. Copy code needed into a blank truffle project

```
docker cp <DOCKER ID>:root/ZoKrates/verifier.sol ./contracts
docker cp <DOCKER ID>:root/ZoKrates/proving.key ./
docker cp <DOCKER ID>:root/ZoKrates/out ./
docker cp <DOCKER ID>:root/ZoKrates/variables.inf ./
```

5. For each user Compute Witness and Generate the Proof

```
./zokrates compute-witness -a <INPUTS>
./zokrates generate-proof > <FILE that contains Proof Information>
```

6. Copy the Proof File to Current Project 'proofs' Directory

```
docker cp <DOCKER ID>:<Path to Proof File> ./proofs
```

7. Run ./convertproof.py inside the 'proofs' directory. This outputs the proof information as JSON object in the form of userID: [A, A_p, B, B_p, C, C_p, H, K] as well as correct types to be used in Web3.

### Issues

1. **userHash as input to ZoKrates High-Level Code**: We talked about how it would be good if we had a userHash to be the input to verifyTx, so the third-party could confirm the identity of the person they were confirming the VIP Score of. However, .code functions that are compiled by ZoKrates only took in integers as parameters and therefore the userHash was not accepted. I settled on just inputting userID which simply the number of total users when they were added
2. **call() vs sendTransaction()**: SendTransaction invokes verifyTx, modifies the state of the contract, and puts the transaction on chain to be mined. However, it doesn't return the value of verifyTx just a transactionHash. We need verifyTx on-chain for third parties to confirm and trust the system, but we also need the value to display in the UI. I beleive the preferred solution is to log an event and then have web3 get that event and return that to be dispalyed. However, I just returned the call() of verifyTX for simplicity and actually think it saves gas as .call() only simulates a transaction but discards all state changes and therefore uses no gas.
3. **VIP Score Algorithm**: The algorithm used to calculate VIP Score in both the regular ethereum implementation and ZoKrates implementation is basic. It would be nice to implement some simple machine-learning classifier based on features as well as have the third-party input different weights they would like to use or pick from a variety of algorithms that would be used by ZoKrates to generate the proof and create the verifier contract.

References:

1. [Pet Shop Truffle Box](https://truffleframework.com/tutorials/pet-shop)
2. [ZoKrates Tutorial](https://medium.com/extropy-io/zokrates-tutorial-with-truffle-41135a3fb754)
3. [zk-SNARKS w/ Examples](https://media.consensys.net/introduction-to-zksnarks-with-examples-3283b554fc3b)
4. [Vitalik on zk-SNARKS](https://medium.com/@VitalikButerin/zk-snarks-under-the-hood-b33151a013f6)
