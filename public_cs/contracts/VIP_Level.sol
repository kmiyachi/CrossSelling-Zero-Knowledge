pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

contract VIP_Level {

    // User Struct whos elements will be used to determine VIP Level
    struct User {
        uint256 id;                 // ID number for the user
        string name;                // Name of user
        uint256 balance;            // Total Balance in their Account
        uint256 total_deposited;    // Total amount the user has deposited
        uint256 total_withdrawn;    // Total amount withdrawn from the user account
        uint256 debt;               // Outstanding Debt the user has yet to pay

        uint256 usage_score;        // 1-10 based on how often the user uses the banking service
        uint256 pay_score;          // 1-10 based on how good they are at paying their bills
    }


    // Keeps track of ID Number (Count of Users)
    uint256 id_num;

    //List of all Users
    User[] allUsers;  

    //Mappings from ID -> User and ID -> VIP Score
    mapping(uint256=>User) BankUser;
    mapping(uint256=>uint256) VIPScore;

    event UserAdd(string user);

    
    constructor() public {
        addUser("Ken");
        addBalance(1,1000);
        addUser("Yijia");
        addUser("Nick");
        addUser("Melissa");
        addUser("Mari");
        addUser("Nicoli");
        addUser("Elon");
        addUser("Benjamin");
        addUser("Franklin");
        addUser("Franz");
    }

    function getAllUsers() public view returns (User[]) {
        return allUsers;
    }
    
    function getUser(uint256 id) public view returns (string) {
        User user = BankUser[id];
        return user.name;
    }

    function getVIP(uint256 id) public view returns (uint256) {
        return VIPScore[id];
    }

    function addUser(string name) public returns (uint256) {
        id_num = id_num + 1;
        User memory newUser = User(id_num, name, 0, 5 ,random(0,100), random(0,100), random(0,100), random(0,100));
        allUsers.push(newUser);
        BankUser[id_num] = newUser;
        emit UserAdd(name);
        return calculate_VIP(id_num);
        
    }


    function bytes32ToString (bytes32 data) public returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j = 0; j < 32; j++ ) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }

    uint nonce = 0;
    function random(uint min, uint max) public returns (uint){
        nonce++;
        return uint(keccak256(nonce))%(min+max)-min;
    }


    function calculate_VIP(uint256 _id) public returns (uint256) {
        User memory _user = BankUser[_id];
        uint256 VIP = _user.balance + _user.total_deposited + _user.total_withdrawn + _user.usage_score + _user.pay_score - _user.debt;
        VIPScore[_user.id] = VIP;
        return VIP;
    }

    function addBalance(uint256 _id, uint256 amount) public {
        User user = BankUser[_id];
        user.balance = user.balance + amount;
    }

    function getBalance(uint256 id) public returns (uint256) {
        return BankUser[id].balance;
    }
}