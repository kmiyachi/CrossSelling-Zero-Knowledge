from web3.contract import ConciseContract
from web3 import Web3, HTTPProvider
import json

w3 = Web3(HTTPProvider('http://localhost:8545'))

x = ""
with open("./abi.txt") as f:
    x = "".join(line.strip() for line in f)
print()
# Get the address and ABI of the contract
verifier = Web3.toChecksumAddress('0x9da037af58a3fb4c2c7ff8c0814463aa6631b872')
abi = json.loads(x)

# Create a contract object
contract = w3.eth.contract(
    address=verifier,
    abi=abi
)

# Proof generated from Zokrates


A = [0x2dace814e772525d901580bf2dcad21fe6459b5437656b95856825386af8ee91,
     0x2efd0f520ddbb18e9aa24b95c8dcf34a182f43e3040d7e0462ecd1f7d20845c2]
A_p = [0x78c886c8b33ba46df41e1b80d0da19b2ad943e583f6c369fa6e4e75de2b23d8,
       0xc2f97b9d5b5310fdecd43cda192790d692ccf5bd23f9bcd90365d4d2f2f9b9f]
B = [[0x1b2362c5b90d4a793fc6996d6f0a19dd610ff3d71874ab398567cd571a9250aa, 0xecf552b5c810f905e7ad8fd3c66264118b0a04fbf9e452da286a61d47b68be0], [
    0x9afcb241804da8000915fa6654a4fbdb7f5aa576cbb90a448e8aef7ebeaec60, 0x2a6a557933e73e997c25efde433b4abece9d495fd72b5ec3a34c8016b403d066]]
B_p = [0x20b2afea9dcaa67ff3b06b5f67c538e0f7d0aae5b007297f386fc213fdee2c5f,
       0x1849aa86ceff577d00ebe394250d6dddf00fe1b2d43f9516c94c42b87aab5a3a]
C = [0x287e32affc258ef4df70b37114b56fc8b51858e438e3d495516fd4ab60d5519b,
     0x1febfacf6407e12484a403dead830a83e577cadad87346a496dc11c50235da23]
C_p = [0xef17bb811123d5ec443c954bd7d0ccf65b0abba3e203c51a9a8eb97c3ca8490,
       0x6c143e8d2be28838db448a78557e015d9d0966dd9e56c54d602e1dcd4ed643c]
H = [0x13bf65b08877be9a0a67b212eccbac52a90fac73eb74fcdb39b1fb5cb180f5ff,
     0x2d7cd0b618ea7d2626f5576da572d2269b333de930d75c1605778ac4631bdcb2]
K = [0x37b4c5ede75d8625c77f9f0caf8354f8680d44f4e5a4d76cf0bcd93f43830ed,
     0x2bd85b4556195ae59414dcbfd5b3d8e2b2f913da70d92eee13b61ca987351bf2]

# Set gas and gas price
params = {
    'gasPrice': 20000000000,
    'gas': 4000000,
    'from': w3.eth.accounts[0],
}

# Correct input
I = [1, 99]

# Verify

print(contract.functions)
txhash = contract.functions.verifyTx(
    A, A_p, B, B_p, C, C_p, H, K, I).call()

# Check success
print(txhash)

# Incorrect input
I = [2, 99]

# Verify
txhash = contract.functions.verifyTx(
    A, A_p, B, B_p, C, C_p, H, K, I).call()

# Check success
print(txhash)


# weights = contract.functions.getWeights().call()
# print(weights)

contract.functions.setWeights((2, 3, 4, 5, 6, 7)).call()
newWeights = contract.functions.getWeights().call()
print(newWeights)
