pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VIP_Level.sol";

contract TestVIP {
    VIP_Level vip = VIP_Level(DeployedAddresses.VIP_Level());

    // Testing the adopt() function
    function testNothing() public {
        vip.addUser("IDK");
        uint256 b = vip.getBalance(1);
        //uint256 s = vip.calculate_VIP(1);
        //uint256 idk = vip.calculate_VIP(2);
        Assert.equal(b,1000,"Score is blank");
    }

}